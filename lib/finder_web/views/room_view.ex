defmodule FinderWeb.RoomView do
  use FinderWeb, :view
  alias FinderWeb.RoomView
  use Timex

  def render("index.json", %{rooms: rooms}) do
    %{data: render_many(rooms, RoomView, "room.json")}
  end

  def render("index_with_detail.json", %{rooms: rooms}) do
    %{data: render_many(rooms, RoomView, "room_detail.json")}
  end

  def render("show.json", %{room: room}) do
    %{data: render_one(room, RoomView, "room.json")}
  end

  def render("show_detail.json", %{room: room}) do
    %{data: render_one(room, RoomView, "room_detail.json")}
  end

  def render("room.json", %{room: room}) do
    %{
      id: room.id,
      lat: room.lat,
      long: room.long,
      address: room.address,
      price: room.price,
      number_of_rooms: room.number_of_rooms,
      state: room.state,
      district_name: room.district_name,
      available: room.available,
      parking_count: room.parking_count,
      amenity_count: room.amenity_count,
      water: water_value(room),
      type: type_value(room),
      phone: room.phone,
      phone_visibility: room.phone_visibility,
      images: get_room_images(room.images),
      posted_on: get_posted_time_in_ago(room)
    }
  end

  def render("room_detail.json", %{room: room}) do
    # water = Finder.Rooms.get_water_type_by_id(room.water)
    # water_value = if is_nil(water), do: "", else: water.value
    # type = Finder.Rooms.get_room_type_by_id(room.type)
    # type_value = if is_nil(type), do: "", else: type.value

    district = %{
      id: room.district.id,
      name: room.district.name,
      state: room.district.state
    }

    %{
      id: room.id,
      lat: room.lat,
      long: room.long,
      address: room.address,
      price: room.price,
      number_of_rooms: room.number_of_rooms,
      state: room.state,
      district_name: room.district_name,
      available: room.available,
      parking_count: room.parking_count,
      amenity_count: room.amenity_count,
      water: water_value(room),
      type: type_value(room),
      images: get_room_images(room.images),
      posted_on: get_posted_time_in_ago(room),
      phone: room.phone,
      phone_visibility: room.phone_visibility,
      district: district,
      parkings: render_many(room.parkings, FinderWeb.ParkingView, "parking.json"),
      amenities: render_many(room.amenities, FinderWeb.AmenityView, "amenity.json"),
      user: render_one(room.user, FinderWeb.UserView, "user_profile.json")
    }
  end

  def water_value(%{water: nil}) do
    nil
  end

  def water_value(%{water: id}) do
    Finder.Rooms.get_water_type_by_id(id).value
  end

  def type_value(%{type: nil}) do
    nil
  end

  def type_value(%{type: id}) do
    Finder.Rooms.get_room_type_by_id(id).value
  end

  def get_room_images(%Ecto.Association.NotLoaded{}) do
    []
  end

  def get_room_images(images) do
    Enum.map(images, fn e -> get_url(e.image) end)
  end

  def get_url(image) do
    url = Finder.ImageUploader.url(image)

    case url do
      nil ->
        ""

      _ ->
        url
    end
  end

  def get_posted_time_in_ago(room) do
    Timex.from_now(room.inserted_at)
  end
end
