defmodule Finder.Chats.Messages do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :content, :string
    field :sender_id, :id
    field :conversation_id, :id

    timestamps()
  end

  @doc false
  def changeset(messages, attrs) do
    messages
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
