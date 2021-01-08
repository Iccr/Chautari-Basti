defmodule FinderWeb.DistrictControllerTest do
  use FinderWeb.ConnCase

  alias Finder.Districts
  alias Finder.Districts.District

  @create_attrs %{
    name: "some name",
    state: 42
  }
  @update_attrs %{
    name: "some updated name",
    state: 43
  }
  @invalid_attrs %{name: nil, state: nil}

  def fixture(:district) do
    {:ok, district} = Districts.create_district(@create_attrs)
    district
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all districts", %{conn: conn} do
      conn = get(conn, Routes.district_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create district" do
    test "renders district when data is valid", %{conn: conn} do
      conn = post(conn, Routes.district_path(conn, :create), district: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.district_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name",
               "state" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.district_path(conn, :create), district: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update district" do
    setup [:create_district]

    test "renders district when data is valid", %{conn: conn, district: %District{id: id} = district} do
      conn = put(conn, Routes.district_path(conn, :update, district), district: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.district_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name",
               "state" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, district: district} do
      conn = put(conn, Routes.district_path(conn, :update, district), district: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete district" do
    setup [:create_district]

    test "deletes chosen district", %{conn: conn, district: district} do
      conn = delete(conn, Routes.district_path(conn, :delete, district))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.district_path(conn, :show, district))
      end
    end
  end

  defp create_district(_) do
    district = fixture(:district)
    %{district: district}
  end
end
