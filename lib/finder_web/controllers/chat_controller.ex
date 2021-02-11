defmodule FinderWeb.ChatController do
  use FinderWeb, :controller

  alias Finder.Chats

  action_fallback FinderWeb.FallbackController

  def index(conn, _params) do
    current_user = conn.assigns.current_user
    conversactions = Chats.list_user_conversations(current_user)

    conn
    |> render("index.json", chats: conversactions)
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
          |> render("show.json", chat: chat)
        end

      [head | _tail] ->
        conn
        |> render("show.json", chat: head)
    end

    # with {:ok, %Conversation{} = conversation} <- Chats.create_conversation(conversations_params) do
    #   conn
    #   |> put_status(:created)
    #   |> render("show.json", conversation: conversation)
    # end
  end
end
