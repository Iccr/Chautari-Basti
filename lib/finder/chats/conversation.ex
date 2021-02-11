defmodule Finder.Chats.Conversation do
  use Ecto.Schema
  import Ecto.Changeset

  alias Finder.Accounts.User
  alias Finder.Chats.Messages

  schema "conversations" do
    # field :sender_id, :id
    # field :recipient_id, :id

    belongs_to :sender, User, foreign_key: :sender_id
    belongs_to :recipient, User, foreign_key: :recipient_id
    has_many :messages, Messages

    timestamps()
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:sender_id, :recipient_id])
    |> validate_required([:sender_id, :recipient_id])
  end
end
