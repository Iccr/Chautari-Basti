defmodule Finder.Chats.Messages do
  use Ecto.Schema
  import Ecto.Changeset
  alias Finder.Chats.Conversation
  alias Finder.Accounts.User

  schema "messages" do
    # field :sender_id, :id
    # field :conversation_id, :id
    field :content, :string
    belongs_to :sender, User, foreign_key: :sender_id
    belongs_to :conversation, Conversation, foreign_key: :conversation_id

    timestamps()
  end

  @doc false
  def changeset(messages, attrs) do
    messages
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
