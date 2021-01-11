defmodule Finder.Waters.Water do
  use Ecto.Schema
  import Ecto.Changeset

  schema "waters" do
    field :name, :string
    field :tag, :integer
    many_to_many :rooms, Finder.Rooms.Room, join_through: Finder.Rooms.RoomWater
    timestamps()
  end

  @doc false
  def changeset(water, attrs) do
    water
    |> cast(attrs, [:name, :tag])
    |> validate_required([:name, :tag])
    |> unique_constraint(:name)
  end
end
