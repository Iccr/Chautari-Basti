defmodule FinderWeb.ChatController do
  use FinderWeb, :controller

  alias Finder.Chats

  action_fallback FinderWeb.FallbackController

  # def index(conn, _params) do
  #   # field :sender_id, :id
  #   # field :recipient_id, :id

  #   current_user = conn.assigns.current_user
  #   conversations = Chats.list_conversations()
  #   render(conn, "index.json", conversations: conversations)
  # end

  # when user goes ty chat view in profile controller in mobile. show list of all  conversations

  def conversation(conn, params) do
    current_user = conn.assigns.current_user
    conversactions = Chats.list_user_conversations(current_user)
  end

  def find_or_create(conn, %{"recipient_id" => recipient_id} = params) do
    current_user = conn.assigns.current_user

    case Chats.find_with_my_id_and_recipient_id(%{
           "sender_id" => current_user.id,
           "recipient_id" => recipient_id
         }) do
      [] ->
        {:ok, chats} =
          Chats.create_conversation(%{
            "sender_id" => current_user.id,
            "recipient_id" => recipient_id
          })

      [head | tail] ->
        nil
    end

    # with {:ok, %Conversation{} = conversation} <- Chats.create_conversation(conversations_params) do
    #   conn
    #   |> put_status(:created)
    #   |> render("show.json", conversation: conversation)
    # end
  end
end
