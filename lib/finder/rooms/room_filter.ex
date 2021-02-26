defmodule Finder.Rooms.Filter do
  import Ecto.Query

  # // address
  def find_address(query \\ Room, address)

  def find_address(query, nil) do
    query
  end

  def find_address(query, address) do
    # address = String.downcase(address)
    address = "%#{String.downcase(address)}%"

    query
    |> where([r], ilike(r.address, ^address))

    # |> where([r], fragment("lower(?)", r.address) == ^address)
  end

  # types

  def find_by_types(query \\ Room, type)

  def find_by_types(query, nil) do
    query
  end

  def find_by_types(query, type) do
    query
    |> where([r], r.type == ^type)
  end

  # number of rooms lower boud

  def find_by_number_of_rooms_lower_bound(query \\ Room, lower)

  def find_by_number_of_rooms_lower_bound(query, nil) do
    query
  end

  def find_by_number_of_rooms_lower_bound(query, lower) do
    IO.inspect(lower)

    query
    |> where([r], r.number_of_rooms >= ^lower)
  end

  # number of rooms upper boud

  def find_by_number_of_rooms_upper_bound(query \\ Room, upper)

  def find_by_number_of_rooms_upper_bound(query, nil) do
    query
  end

  def find_by_number_of_rooms_upper_bound(query, upper) do
    query
    |> where([r], r.number_of_rooms <= ^upper)
  end

  # District

  def find_by_district(query \\ Room, district_name)

  def find_by_district(query, nil) do
    query
  end

  def find_by_district(query, district_name) do
    district_name = "%#{district_name}%"

    query
    |> where([r], ilike(r.district_name, ^district_name))
  end

  # // water

  def find_by_water(query \\ Room, water)

  def find_by_water(query, nil) do
    query
  end

  def find_by_water(query, water) do
    query
    |> where([r], r.water == ^water)
  end

  # price

  # number of rooms upper price

  def find_by_price_upper_bound(query \\ Room, upper)

  def find_by_price_upper_bound(query, nil) do
    query
  end

  def find_by_price_upper_bound(query, upper) do
    query
    |> where([r], r.price <= ^upper)
  end

  # number of rooms lower price

  def find_by_price_lower_bound(query \\ Room, lower)

  def find_by_price_lower_bound(query, nil) do
    query
  end

  def find_by_price_lower_bound(query, lower) do
    query
    |> where([r], r.price >= ^lower)
  end

  # parkings

  def find_by_parkings(query \\ Room, parkings)

  def find_by_parkings(query, nil) do
    query
  end

  def find_by_parkings(query, parkings) do
    query
    |> where([r], r.parkings in ^parkings)
  end

  def order(query) do
    query
    |> order_by(desc: :inserted_at)
  end
end

# field :address, :string
#     field :lat, :decimal
#     field :long, :decimal
#     field :number_of_rooms, :integer ,, done
#     field :price, :decimal ,
#     field :state, :integer
#     field :district_name, :string
#     field :available, :boolean
#     field :parking_count, :integer
#     field :amenity_count, :integer
#     field :water, :integer
#     field :type, :integer
#     field :phone, :string
#     field :phone_visibility, :boolean

#     belongs_to :district, Finder.Districts.District
#     belongs_to :user, Finder.Accounts.User

#     many_to_many :parkings, Finder.Parkings.Parking,
#       join_through: Finder.Rooms.RoomParking,
#       on_replace: :delete

#     many_to_many :amenities, Finder.Amenities.Amenity,
