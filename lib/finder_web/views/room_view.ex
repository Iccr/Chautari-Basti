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
    %{id: room.id,
      lat: room.lat,
      long: room.long,
      address: room.address,
      price: room.price,
      number_of_rooms: room.number_of_rooms}
  end
end
