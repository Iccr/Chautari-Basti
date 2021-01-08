defmodule Finder.Rooms.RoomParking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "room_parkings" do
    # field :room_id, :id
    # field :parking_id, :id
    belongs_to :room, Finder.Rooms.Room
    belongs_to :parking, Finder.Parkings.Parking

    timestamps()
  end

  @doc false
  def changeset(room_parking, attrs) do
    room_parking
    |> cast(attrs, [])
    |> validate_required([])
  end
end
