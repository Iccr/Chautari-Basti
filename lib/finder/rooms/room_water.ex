defmodule Finder.Rooms.RoomWater do
  use Ecto.Schema
  import Ecto.Changeset

  schema "room_waters" do
    field :room_id, :id
    field :water_id, :id

    timestamps()
  end

  @doc false
  def changeset(room_water, attrs) do
    room_water
    |> cast(attrs, [])
    |> validate_required([])
  end
end
