defmodule FinderWeb.AmenityController do
  use FinderWeb, :controller

  alias Finder.Amenities
  alias Finder.Amenities.Amenity

  action_fallback FinderWeb.FallbackController

  def index(conn, _params) do
    amenities = Amenities.list_amenities()
    render(conn, "index.json", amenities: amenities)
  end

  def create(conn, %{"amenity" => amenity_params}) do
    with {:ok, %Amenity{} = amenity} <- Amenities.create_amenity(amenity_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.amenity_path(conn, :show, amenity))
      |> render("show.json", amenity: amenity)
    end
  end

  def show(conn, %{"id" => id}) do
    amenity = Amenities.get_amenity!(id)
    render(conn, "show.json", amenity: amenity)
  end

  def update(conn, %{"id" => id, "amenity" => amenity_params}) do
    amenity = Amenities.get_amenity!(id)

    with {:ok, %Amenity{} = amenity} <- Amenities.update_amenity(amenity, amenity_params) do
      render(conn, "show.json", amenity: amenity)
    end
  end

  def delete(conn, %{"id" => id}) do
    amenity = Amenities.get_amenity!(id)

    with {:ok, %Amenity{}} <- Amenities.delete_amenity(amenity) do
      send_resp(conn, :no_content, "")
    end
  end
end
