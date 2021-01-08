defmodule FinderWeb.AmenityControllerTest do
  use FinderWeb.ConnCase

  alias Finder.Amenities
  alias Finder.Amenities.Amenity

  @create_attrs %{
    name: "some name",
    tag: 42
  }
  @update_attrs %{
    name: "some updated name",
    tag: 43
  }
  @invalid_attrs %{name: nil, tag: nil}

  def fixture(:amenity) do
    {:ok, amenity} = Amenities.create_amenity(@create_attrs)
    amenity
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all amenities", %{conn: conn} do
      conn = get(conn, Routes.amenity_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create amenity" do
    test "renders amenity when data is valid", %{conn: conn} do
      conn = post(conn, Routes.amenity_path(conn, :create), amenity: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.amenity_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name",
               "tag" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.amenity_path(conn, :create), amenity: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update amenity" do
    setup [:create_amenity]

    test "renders amenity when data is valid", %{conn: conn, amenity: %Amenity{id: id} = amenity} do
      conn = put(conn, Routes.amenity_path(conn, :update, amenity), amenity: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.amenity_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name",
               "tag" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, amenity: amenity} do
      conn = put(conn, Routes.amenity_path(conn, :update, amenity), amenity: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete amenity" do
    setup [:create_amenity]

    test "deletes chosen amenity", %{conn: conn, amenity: amenity} do
      conn = delete(conn, Routes.amenity_path(conn, :delete, amenity))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.amenity_path(conn, :show, amenity))
      end
    end
  end

  defp create_amenity(_) do
    amenity = fixture(:amenity)
    %{amenity: amenity}
  end
end
