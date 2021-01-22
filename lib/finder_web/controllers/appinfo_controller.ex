defmodule FinderWeb.AppinfoController do
  use FinderWeb, :controller
  alias Finder.Amenities
  alias Finder.Parkings
  alias Finder.Districts

  def index(conn, _params) do
    parkings = Parkings.list_parkings()
    amenities = Amenities.list_amenities()
    districts = Districts.list_districts()

    render(conn, "index.json",
      amenities: amenities,
      parkings: parkings,
      districts: districts
    )
  end
end
