defmodule FinderWeb.AppinfoView do
  use FinderWeb, :view
  alias FinderWeb.AppinfoView

  alias FinderWeb.ParkingView
  alias FinderWeb.AmenityView
  alias FinderWeb.DistrictView

  def render("index.json", %{
        amenities: amenities,
        parkings: parkings,
        districts: districts,
        waters: waters,
        types: types
      }) do
    %{
      data: %{
        parkings: render_many(parkings, ParkingView, "parking.json"),
        amenities: render_many(amenities, AmenityView, "amenity.json"),
        districts: render_many(districts, DistrictView, "district.json"),
        waters: render_many(waters, AppinfoView, "water.json"),
        types: render_many(types, AppinfoView, "types.json")
      }
    }
  end

  def render("water.json", %{appinfo: water}) do
    %{name: water.name, value: water.value}
  end

  def render("types.json", %{appinfo: types}) do
    %{name: types.name, value: types.value}
  end
end
