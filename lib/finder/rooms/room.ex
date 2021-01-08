defmodule Finder.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :address, :string
    field :lat, :decimal
    field :long, :decimal
    field :number_of_rooms, :integer
    field :price, :decimal
    field :state, :integer
    field :district_name, :string
    belongs_to :district, Finder.Districts.District
    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:lat, :long, :address, :price, :number_of_rooms])
    |> validate_required([:lat, :long, :address, :price, :number_of_rooms])
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
