defmodule FinderWeb.RentRoomChannel do
  use FinderWeb, :channel
  alias FinderWeb.RoomPresence
  alias Finder.Chats

  @impl true
  def join("rent_room:" <> _conversation_id, payload, socket) do
    if authorized?(socket, payload) do
      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # def join("rent_room:loby", payload, socket) do
  #   if authorized?(socket, payload) do
  #     {:ok, socket}
  #   else
  #     {:error, %{reason: "unauthorized"}}
  #   end
  # end

  # def handle_in(
  #       "rent_room:presence_update",
  #       %{"user_id" => user_id, "in_room" => in_room} = _payload,
  #       socket
  #     ) do
  #   if Guardian.Phoenix.Socket.authenticated?(socket) do
  #     RoomPresence.update(socket, user_id, %{
  #       user_id: user_id,
  #       in_room: in_room
  #     })

  #     broadcast(socket, "presence_state", RoomPresence.list(socket))

  #     {:noreply, socket}
  #   end
  # end

  #  conversation from the users are routed from here. authorized and saved to database
  @impl true
  def handle_in("shout", payload, socket) do
    if Guardian.Phoenix.Socket.authenticated?(socket) do
      Chats.create_message(payload)
      IO.inspect("shout room channel")
      broadcast(socket, "shout", payload)
      {:noreply, socket}
    end
  end

  # called as soon as user joins the rent_room channel. authorized and tracked the room presence

  @impl true
  @spec handle_info(:after_join, Phoenix.Socket.t()) :: {:noreply, Phoenix.Socket.t()}
  def handle_info(:after_join, socket) do
    broadcast(socket, "presence_state", RoomPresence.list(socket))
    user_id = socket.assigns.guardian_default_resource.id

    {:ok, _} =
      RoomPresence.track(socket, user_id, %{
        user_id: user_id,
        in_room: true
      })

    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(socket, _payload) do
    Guardian.Phoenix.Socket.authenticated?(socket)
  end
end
