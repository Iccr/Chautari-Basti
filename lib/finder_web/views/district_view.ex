defmodule FinderWeb.DistrictView do
  use FinderWeb, :view
  alias FinderWeb.DistrictView

  def render("index.json", %{districts: districts}) do
    %{data: render_many(districts, DistrictView, "district.json")}
  end

  def render("show.json", %{district: district}) do
    %{data: render_one(district, DistrictView, "district.json")}
  end

  def render("district.json", %{district: district}) do
    IO.inspect(district)

    %{
      id: district.id,
      state: district.state,
      name: district.name,
      rooms: render_rooms(district.rooms)
    }
  end

  defp render_rooms(%Ecto.Association.NotLoaded{}) do
    render_many([], FinderWeb.RoomView, "room.json")
  end

  defp render_rooms(rooms) do
    render_many(rooms, FinderWeb.RoomView, "room.json")
  end
end
