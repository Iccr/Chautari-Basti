defmodule FinderWeb.RoomControllerTest do
  use FinderWeb.ConnCase

  alias Finder.Rooms
  alias Finder.Rooms.Room

  @create_attrs %{
    address: "some address",
    lat: "120.5",
    long: "120.5",
    number_of_rooms: 42,
    price: "120.5"
  }
  @update_attrs %{
    address: "some updated address",
    lat: "456.7",
    long: "456.7",
    number_of_rooms: 43,
    price: "456.7"
  }
  @invalid_attrs %{address: nil, lat: nil, long: nil, number_of_rooms: nil, price: nil}

  def fixture(:room) do
    {:ok, room} = Rooms.create_room(@create_attrs)
    room
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all rooms", %{conn: conn} do
      conn = get(conn, Routes.room_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create room" do
    test "renders room when data is valid", %{conn: conn} do
      conn = post(conn, Routes.room_path(conn, :create), room: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.room_path(conn, :show, id))

      assert %{
               "id" => id,
               "address" => "some address",
               "lat" => "120.5",
               "long" => "120.5",
               "number_of_rooms" => 42,
               "price" => "120.5"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.room_path(conn, :create), room: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update room" do
    setup [:create_room]

    test "renders room when data is valid", %{conn: conn, room: %Room{id: id} = room} do
      conn = put(conn, Routes.room_path(conn, :update, room), room: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.room_path(conn, :show, id))

      assert %{
               "id" => id,
               "address" => "some updated address",
               "lat" => "456.7",
               "long" => "456.7",
               "number_of_rooms" => 43,
               "price" => "456.7"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, room: room} do
      conn = put(conn, Routes.room_path(conn, :update, room), room: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete room" do
    setup [:create_room]

    test "deletes chosen room", %{conn: conn, room: room} do
      conn = delete(conn, Routes.room_path(conn, :delete, room))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.room_path(conn, :show, room))
      end
    end
  end

  defp create_room(_) do
    room = fixture(:room)
    %{room: room}
  end
end
