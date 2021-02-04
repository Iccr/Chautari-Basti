defmodule Finder.Amenities.Amenity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "amenities" do
    field :name, :string
    field :tag, :integer

    many_to_many :rooms, Finder.Amenities.Amenity,
      join_through: Finder.Rooms.RoomAmenity,
      on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(amenity, attrs) do
    amenity
    |> cast(attrs, [:name, :tag])
    |> validate_required([:name, :tag])
    |> unique_constraint(:name)
  end
end
