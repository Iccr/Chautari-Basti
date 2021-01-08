defmodule Finder.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :address, :string
    field :lat, :decimal
    field :long, :decimal
    field :number_of_rooms, :integer
    field :price, :decimal

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:lat, :long, :address, :price, :number_of_rooms])
    |> validate_required([:lat, :long, :address, :price, :number_of_rooms])
  end
end
