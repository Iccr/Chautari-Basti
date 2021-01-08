defmodule FinderWeb.WaterController do
  use FinderWeb, :controller

  alias Finder.Waters
  alias Finder.Waters.Water

  action_fallback FinderWeb.FallbackController

  def index(conn, _params) do
    waters = Waters.list_waters()
    render(conn, "index.json", waters: waters)
  end

  def create(conn, %{"water" => water_params}) do
    with {:ok, %Water{} = water} <- Waters.create_water(water_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.water_path(conn, :show, water))
      |> render("show.json", water: water)
    end
  end

  def show(conn, %{"id" => id}) do
    water = Waters.get_water!(id)
    render(conn, "show.json", water: water)
  end

  def update(conn, %{"id" => id, "water" => water_params}) do
    water = Waters.get_water!(id)

    with {:ok, %Water{} = water} <- Waters.update_water(water, water_params) do
      render(conn, "show.json", water: water)
    end
  end

  def delete(conn, %{"id" => id}) do
    water = Waters.get_water!(id)

    with {:ok, %Water{}} <- Waters.delete_water(water) do
      send_resp(conn, :no_content, "")
    end
  end
end
