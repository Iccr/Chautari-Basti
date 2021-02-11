defmodule FinderWeb.MessageView do
  use FinderWeb, :view

  alias FinderWeb.MessageView

  def render("index.json", %{message: conversations}) do
    %{data: %{messages: render_many(conversations, MessageView, "message.json")}}
  end

  def render("message.json", %{message: message}) do
    %{
      sender_id: message.sender_id,
      conversation_id: message.conversation_id,
      content: message.content
    }
  end
end
