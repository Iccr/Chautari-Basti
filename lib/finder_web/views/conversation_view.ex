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
      sender_name: conversation.sender.name,
      recipient_id: conversation.recipient_id,
      recipient_name: conversation.recipient.name,
      messages: render_messages(conversation.messages)
    }
  end

  defp render_messages(%Ecto.Association.NotLoaded{}) do
    render_many([], MessageView, "message.json")
  end

  defp render_messages(messages) do
    render_many(messages, MessageView, "message.json")
  end
end
