defmodule FinderWeb.RentRoomChannel do
  use FinderWeb, :channel

  @impl true
  def join("rent_room:lobby", payload, socket) do
    if authorized?(socket, payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client

  # @impl true
  # def handle_in("ping", payload, socket) do
  #   handle_in("shout", payload, socket)
  #   {:reply, {:ok, payload}, socket}
  # end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (rent_room:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    if Guardian.Phoenix.Socket.authenticated?(socket) do
      broadcast(socket, "shout", payload)
      {:noreply, socket}
    end
  end

  # Add authorization logic here as required.
  defp authorized?(socket, _payload) do
    Guardian.Phoenix.Socket.authenticated?(socket)
  end
end
