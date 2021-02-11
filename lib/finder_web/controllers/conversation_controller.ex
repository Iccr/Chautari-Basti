defmodule FinderWeb.Conversations do
  use FinderWeb, :controller

  alias Finder.Chats.Conversation

  action_fallback FinderWeb.FallbackController

  def index(conn, _params) do
    conversations = Chats.list_conversations()
    render(conn, "index.json", conversations: conversations)
  end

  def create(conn, conversations_params) do
    with {:ok, %Conversation{} = conversation} <- Chats.create_conversation(conversations_params) do
      conn
      |> put_status(:created)
      |> render("show.json", conversation: conversation)
    end
  end
end
