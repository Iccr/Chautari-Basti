defmodule Finder.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @attrs ~w(email imageurl name token provider)a

  schema "users" do
    field :email, :string
    field :imageurl, :string
    field :name, :string
    field :token, :string
    field :provider, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @attrs)
    |> validate_required(@attrs)
    |> unique_constraint(:email)
  end
end
