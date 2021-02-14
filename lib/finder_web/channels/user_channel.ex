defmodule FinderWeb.UserChannel do
  use FinderWeb, :channel

  alias FinderWeb.UserPresence

  @impl true
  def join("user_channel:loby", payload, socket) do
    if authorized?(socket, payload) do
      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in(
        "user_channel:presence_update",
        %{"typing" => typing, "user_id" => user_id} = _payload,
        socket
      ) do
    if Guardian.Phoenix.Socket.authenticated?(socket) do
      UserPresence.update(socket, user_id, %{
        user_id: user_id,
        typing: typing
      })

      broadcast(socket, "presence_state", UserPresence.list(socket))

      {:noreply, socket}
    end
  end

  @impl true
  def handle_info(:after_join, socket) do
    user_id = socket.assigns.guardian_default_resource.id

    {:ok, _} =
      UserPresence.track(socket, user_id, %{
        user_id: user_id,
        typing: false
      })

    broadcast(socket, "presence_state", UserPresence.list(socket))

    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(socket, _payload) do
    Guardian.Phoenix.Socket.authenticated?(socket)
  end
end
