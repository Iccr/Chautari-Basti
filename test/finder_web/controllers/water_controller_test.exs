defmodule FinderWeb.WaterControllerTest do
  use FinderWeb.ConnCase

  alias Finder.Waters
  alias Finder.Waters.Water

  @create_attrs %{
    name: "some name",
    tag: 42
  }
  @update_attrs %{
    name: "some updated name",
    tag: 43
  }
  @invalid_attrs %{name: nil, tag: nil}

  def fixture(:water) do
    {:ok, water} = Waters.create_water(@create_attrs)
    water
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all waters", %{conn: conn} do
      conn = get(conn, Routes.water_path(conn, :index))
      assert json_response(conn, 200)["data"] != []
    end
  end

  # describe "create water" do
  #   test "renders water when data is valid", %{conn: conn} do
  #     conn = post(conn, Routes.water_path(conn, :create), water: @create_attrs)
  #     assert %{"id" => id} = json_response(conn, 201)["data"]

  #     conn = get(conn, Routes.water_path(conn, :show, id))

  #     assert %{
  #              "id" => id,
  #              "name" => "some name",
  #              "tag" => 42
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post(conn, Routes.water_path(conn, :create), water: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "update water" do
  #   setup [:create_water]

  #   test "renders water when data is valid", %{conn: conn, water: %Water{id: id} = water} do
  #     conn = put(conn, Routes.water_path(conn, :update, water), water: @update_attrs)
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get(conn, Routes.water_path(conn, :show, id))

  #     assert %{
  #              "id" => id,
  #              "name" => "some updated name",
  #              "tag" => 43
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, water: water} do
  #     conn = put(conn, Routes.water_path(conn, :update, water), water: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete water" do
  #   setup [:create_water]

  #   test "deletes chosen water", %{conn: conn, water: water} do
  #     conn = delete(conn, Routes.water_path(conn, :delete, water))
  #     assert response(conn, 204)

  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.water_path(conn, :show, water))
  #     end
  #   end
  # end

  defp create_water(_) do
    water = fixture(:water)
    %{water: water}
  end
end
