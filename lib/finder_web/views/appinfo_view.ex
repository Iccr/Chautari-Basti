defmodule FinderWeb.AppinfoView do
  use FinderWeb, :view
  alias FinderWeb.ParkingView
  alias FinderWeb.AmenityView
  alias FinderWeb.DistrictView

  def render("index.json", %{amenities: amenities, parkings: parkings, districts: districts}) do
    %{
      data: %{
        parkings: render_many(amenities, ParkingView, "parking.json"),
        amenities: render_many(parkings, AmenityView, "amenity.json"),
        districts: render_many(districts, DistrictView, "district.json")
      }
    }
  end
end
