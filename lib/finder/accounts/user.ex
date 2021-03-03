defmodule Finder.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @attrs ~w(email imageurl name provider fuid fcm)a
  @required ~w(provider fcm)a

  schema "users" do
    field :email, :string
    field :imageurl, :string
    field :name, :string
    field :token, :string
    field :provider, :string
    field :auth_token, :string, virtual: true
    field :fuid, :string
    field :fcm, :string
    has_many :rooms, Finder.Rooms.Room

    has_many :sender_conversations, Finder.Chats.Conversation, foreign_key: :sender_id
    has_many :recipient_conversations, Finder.Chats.Conversation, foreign_key: :recipient_id
    has_many :messages, Finder.Chats.Messages, foreign_key: :sender_id
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @attrs)
    |> validate_required(@required)
    |> unique_constraint(:email)
  end
end
