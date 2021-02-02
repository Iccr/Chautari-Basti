defmodule FinderWeb.AppinfoController do
  use FinderWeb, :controller
  alias Finder.Amenities
  alias Finder.Parkings
  alias Finder.Districts
  alias Finder.Rooms

  def index(conn, _params) do
    parkings = Parkings.list_parkings()
    amenities = Amenities.list_amenities()
    districts = Districts.list_districts()

    waters = Rooms.water_types()
    types = Rooms.room_types()

    render(conn, "index.json",
      amenities: amenities,
      parkings: parkings,
      districts: districts,
      waters: waters,
      types: types
    )
  end
end
