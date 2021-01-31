defmodule Finder.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  @permit_fields ~w(lat long address number_of_rooms price state district_name available water)a
  @required_fields ~w(lat long address number_of_rooms price  available water)a

  schema "rooms" do
    field :address, :string
    field :lat, :decimal
    field :long, :decimal
    field :number_of_rooms, :integer
    field :price, :decimal
    field :state, :integer
    field :district_name, :string
    field :available, :boolean
    field :parking_count, :integer
    field :amenity_count, :integer
    field :water, :integer
    belongs_to :district, Finder.Districts.District
    belongs_to :user, Finder.Accounts.User
    many_to_many :parkings, Finder.Parkings.Parking, join_through: Finder.Rooms.RoomParking
    many_to_many :amenities, Finder.Amenities.Amenity, join_through: Finder.Rooms.RoomAmenity
    has_many :images, Finder.Images.Image

    timestamps()
  end

  @doc false

  def changeset(room, attrs) do
    room
    |> cast(attrs, @permit_fields)
    |> validate_required(@required_fields)
    |> validate_presence_of_district(attrs)
    |> validate_required_image_association(attrs)
    |> validate_length(:images, min: 1)
  end

  def validate_presence_of_district(changeset, attrs) do
    case attrs["district"] do
      nil ->
        add_error(changeset, :district, "district must be present")

      _ ->
        changeset
    end
  end

  defp validate_required_image_association(changeset, attrs) do
    case attrs["images"] do
      nil ->
        add_error(changeset, :images, "Please add at least one image")

      _ ->
        changeset
    end
  end
end
