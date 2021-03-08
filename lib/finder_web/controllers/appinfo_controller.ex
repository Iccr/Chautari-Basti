defmodule FinderWeb.AppinfoController do
  require Logger
  use FinderWeb, :controller
  alias Finder.Amenities
  alias Finder.Parkings
  alias Finder.Districts
  alias Finder.Rooms
  alias Finder.Setting

  def index(conn, _params) do
    parkings = Parkings.list_parkings()
    amenities = Amenities.list_amenities()
    districts = Districts.list_districts()
    config = Setting.get_app_info!(1)

    waters = Rooms.water_types()
    types = Rooms.room_types()
    Logger.debug(types)

    render(conn, "index.json",
      amenities: amenities,
      parkings: parkings,
      districts: districts,
      waters: waters,
      types: types,
      config: config
    )
  end
end
