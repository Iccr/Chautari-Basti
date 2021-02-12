defmodule FinderWeb.ChatView do
  use FinderWeb, :view

  alias FinderWeb.ChatView
  alias FinderWeb.ConversationView

  def render("index.json", %{chats: chats}) do
    %{data: render_many(chats, ConversationView, "conversation.json")}
  end

  def render("show.json", %{chats: chat}) do
    %{data: render_one(chat, ConversationView, "conversation.json")}
  end
end
