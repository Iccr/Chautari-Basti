defmodule FinderWeb.RentRoomChannel do
  use FinderWeb, :channel
  alias Finder.Chats
  @impl true
  def join("rent_room" <> _conversation_id, payload, socket) do
    if authorized?(socket, payload) do
      send(self(), :after_join)
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
    # broadcast(socket, "sent_message", %{})
    # id = String.split(socket.topic, ":") |> Enum.at(1)

    # Finder.Chats.get_messages_for_conversation_id(id)
    # |> Enum.each(fn msg ->
    #   broadcast(socket, "shout", %{
    #     content: msg.content,
    #     conversation_id: msg.conversation_id,
    #     sender_id: msg.sender_id
    #   })
    # end)

    # broadcast(socket, "sent", %{"event" => "done"})

    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(socket, _payload) do
    Guardian.Phoenix.Socket.authenticated?(socket)
  end
end
