defmodule FinderWeb.ChatView do
  use FinderWeb, :view

  alias FinderWeb.ChatView
  alias FinderWeb.ConversationView

  def render("index.json", %{chat: chats}) do
    %{data: %{chats: render_many(chats, ChatView, "chat.json")}}
  end

  def render("show.json", %{chat: chat}) do
    %{data: render_one(chat, ConversationView, "conversation.json")}
  end
end
