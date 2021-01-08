defmodule FinderWeb.ParkingController do
  use FinderWeb, :controller

  alias Finder.Parkings
  alias Finder.Parkings.Parking

  action_fallback FinderWeb.FallbackController

  def index(conn, _params) do
    parkings = Parkings.list_parkings()
    render(conn, "index.json", parkings: parkings)
  end

  def create(conn, %{"parking" => parking_params}) do
    with {:ok, %Parking{} = parking} <- Parkings.create_parking(parking_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.parking_path(conn, :show, parking))
      |> render("show.json", parking: parking)
    end
  end

  def show(conn, %{"id" => id}) do
    parking = Parkings.get_parking!(id)
    render(conn, "show.json", parking: parking)
  end

  def update(conn, %{"id" => id, "parking" => parking_params}) do
    parking = Parkings.get_parking!(id)

    with {:ok, %Parking{} = parking} <- Parkings.update_parking(parking, parking_params) do
      render(conn, "show.json", parking: parking)
    end
  end

  def delete(conn, %{"id" => id}) do
    parking = Parkings.get_parking!(id)

    with {:ok, %Parking{}} <- Parkings.delete_parking(parking) do
      send_resp(conn, :no_content, "")
    end
  end
end
