defmodule Finder.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  @permit_fields ~w(lat long address number_of_rooms price state district_name available)a
  @required_fields ~w(lat long address number_of_rooms price  available)a

  schema "rooms" do
    field :address, :string
    field :lat, :decimal
    field :long, :decimal
    field :number_of_rooms, :integer
    field :price, :decimal
    field :state, :integer
    field :district_name, :string
    field :available, :boolean
    belongs_to :district, Finder.Districts.District
    many_to_many :parkings, Finder.Parkings.Parking, join_through: Finder.Rooms.RoomParking
    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, @permit_fields)
    |> validate_required(@required_fields)
  end

  def create_changeset(room, attrs) do
    room
    |> cast(attrs, @permit_fields)
    |> validate_required(@required_fields)
    |> validate_presence_of_district(attrs)
  end

  def validate_presence_of_district(changeset, attrs) do
    case attrs["district"] do
      nil ->
        add_error(changeset, :district, "district must be present")

      _ ->
        changeset
    end
  end
end
