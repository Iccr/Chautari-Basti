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
    from(r in query,
      inner_join: rp in Finder.Rooms.RoomParking,
      on: rp.room_id == r.id,
      inner_join: p in Finder.Parkings.Parking,
      on: p.id == rp.parking_id,
      where: p.id in ^parkings
    )
  end

  def find_by_amenities(query \\ Room, amenities)

  def find_by_amenities(query, nil) do
    query
  end

  def find_by_amenities(query, amenities) do
    from(r in query,
      inner_join: ra in Finder.Rooms.RoomAmenity,
      on: ra.room_id == r.id,
      inner_join: a in Finder.Amenities.Amenity,
      on: a.id == ra.amenity_id,
      where: a.id in ^amenities
    )
  end

  def order(query) do
    query
    |> order_by(desc: :inserted_at)
  end
end
