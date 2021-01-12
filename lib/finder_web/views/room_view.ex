defmodule FinderWeb.RoomView do
  use FinderWeb, :view
  alias FinderWeb.RoomView

  def render("index.json", %{rooms: rooms}) do
    %{data: render_many(rooms, RoomView, "room.json")}
  end

  def render("show.json", %{room: room}) do
    %{data: render_one(room, RoomView, "room.json")}
  end

  def render("room.json", %{room: room}) do
    water_value = Finder.Rooms.get_water_type_by_id(room.water).name
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
      water: water_value
    }
  end
end
