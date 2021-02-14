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

  @impl true
  def join("user_room:loby", payload, socket) do
    if authorized?(socket, payload) do
      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # def handle_in(
  #       "user_room:presence_update",
  #       %{"typing" => typing, "user_id" => user_id} = _payload,
  #       socket
  #     ) do
  #   if Guardian.Phoenix.Socket.authenticated?(socket) do
  #     IO.puts("before update")
  #     IO.inspect(RoomPresence.list(socket))

  #     RoomPresence.update(socket, user_id, %{
  #       user_id: user_id,
  #       typing: typing
  #     })

  #     IO.puts("after update")
  #     IO.inspect(RoomPresence.list(socket))
  #     broadcast(socket, "presence_state", RoomPresence.list(socket))

  #     {:noreply, socket}
  #   end
  # end

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
      Chats.create_message(payload)
      broadcast(socket, "shout", payload)
      {:noreply, socket}
    end
  end

  # data['content'] = this.content;
  #   data['conversation_id'] = this.conversationId;
  #   data['sender_id'] = this.senderId;

  @impl true
  @spec handle_info(:after_join, Phoenix.Socket.t()) :: {:noreply, Phoenix.Socket.t()}
  def handle_info(:after_join, socket) do
    user_id = socket.assigns.guardian_default_resource.id

    {:ok, _} =
      RoomPresence.track(socket, user_id, %{
        user_id: user_id,
        typing: false
      })

    broadcast(socket, "presence_state", RoomPresence.list(socket))
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(socket, _payload) do
    Guardian.Phoenix.Socket.authenticated?(socket)
  end
end
