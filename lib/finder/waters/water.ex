defmodule Finder.Waters.Water do
  use Ecto.Schema
  import Ecto.Changeset

  schema "waters" do
    field :name, :string
    field :tag, :integer

    timestamps()
  end

  @doc false
  def changeset(water, attrs) do
    water
    |> cast(attrs, [:name, :tag])
    |> validate_required([:name, :tag])
  end
end
