defmodule FinderWeb.ConversationView do
  use FinderWeb, :view

  alias FinderWeb.ConversationView

  def render("index.json", %{conversations: conversations}) do
    %{data: %{conversations: render_many(conversations, ConversationView, "conversation.json")}}
  end

  def render("conversation.json", %{conversation: conversation}) do
    %{sender_id: conversation.id, recipient_id: conversation.recipient_id}
  end
end
