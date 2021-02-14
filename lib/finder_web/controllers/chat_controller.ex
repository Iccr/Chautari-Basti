defmodule FinderWeb.ChatController do
  use FinderWeb, :controller

  alias Finder.Chats

  action_fallback FinderWeb.FallbackController

  def index(conn, _params) do
    current_user = conn.assigns.current_user
    user = Chats.list_user_conversations(current_user)

    conversations = user.recipient_conversations ++ user.sender_conversations

    conn
    |> render("index.json", chats: conversations)
  end

  def create(conn, %{"recipient_id" => recipient_id} = _params) do
    current_user = conn.assigns.current_user

    case Chats.find_with_my_id_and_recipient_id(%{
           "sender_id" => current_user.id,
           "recipient_id" => recipient_id
         }) do
      [] ->
        with {:ok, chat} <-
               Chats.create_conversation(%{
                 "sender_id" => current_user.id,
                 "recipient_id" => recipient_id
               }) do
          conn
          |> put_status(:created)
          |> render("index.json", chats: [chat])
        end

      result ->
        conn
        |> render("index.json", chats: result)
    end

    # with {:ok, %Conversation{} = conversation} <- Chats.create_conversation(conversations_params) do
    #   conn
    #   |> put_status(:created)
    #   |> render("show.json", conversation: conversation)
    # end
  end
end
