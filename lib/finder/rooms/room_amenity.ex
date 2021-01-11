defmodule Finder.Rooms.RoomAmenity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "room_amenities" do
    # field :room_id, :id
    # field :amenity_id, :id
    belongs_to :room, Finder.Rooms.Room
    belongs_to :Amenity, Finder.Amenities.Amenity

    timestamps()
  end

  @doc false
  def changeset(room_amenity, attrs) do
    room_amenity
    |> cast(attrs, [])
    |> validate_required([])
  end
end
