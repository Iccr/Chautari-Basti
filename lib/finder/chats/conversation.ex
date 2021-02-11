defmodule Finder.Chats.Conversation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "conversations" do
    field :sender_id, :id
    field :recipient_id, :id

    timestamps()
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [])
    |> validate_required([])
  end
end
