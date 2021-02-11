defmodule FinderWeb.ConversationView do
  use FinderWeb, :view

  alias FinderWeb.ConversationView
  alias FinderWeb.MessageView

  def render("index.json", %{conversations: conversations}) do
    %{data: %{conversations: render_many(conversations, ConversationView, "conversation.json")}}
  end

  def render("show.json", %{conversation: conversation}) do
    %{data: render_one(conversation, ConversationView, "conversation.json")}
  end

  def render("conversation.json", %{conversation: conversation}) do
    %{
      id: conversation.id,
      sender_id: conversation.sender_id,
      recipient_id: conversation.recipient_id,
      messages: render_many(conversation.messages, MessageView, "message.json")
    }
  end
end
