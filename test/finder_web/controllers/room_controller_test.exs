defmodule FinderWeb.RoomControllerTest do
  use FinderWeb.ConnCase

  alias Finder.Rooms
  alias Finder.Rooms.Room

  @create_attrs %{
    "address" => "satdobato",
    "available" => true,
    "district" => 2,
    "lat" => "27.7172",
    "long" => "85.3240",
    "number_of_rooms" => "1",
    "price" => "3000",
    "water" => nil
  }

  @update_attrs %{
    "address" => "satdobato",
    "available" => true,
    "district" => 2,
    "lat" => "27.7172",
    "long" => "85.3240",
    "number_of_rooms" => "1",
    "price" => "3000"
  }
  @invalid_attrs %{
    "address" => nil,
    "available" => nil,
    "lat" => nil,
    "long" => nil,
    "number_of_rooms" => nil,
    "price" => "3000"
  }

  def fixture(:room) do
    district = Finder.Districts.list_districts() |> Enum.at(0)
    map = %{@create_attrs | "district" => district.id}
    {:ok, room} = Rooms.create_room(map)
    room
  end

  def fixture(:district) do
    {:ok, district} = Finder.Districts.create_district(%{name: "Kathmandu", state: 3})
    district
  end

  setup %{conn: conn} do
    Ecto.Adapters.SQL.Sandbox.checkout(Finder.Repo)
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
      district = Finder.Districts.list_districts() |> Enum.at(0)
      new_attrs = %{@create_attrs | "district" => district.id}

      conn = post(conn, Routes.room_path(conn, :create), room: new_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]
      conn = get(conn, Routes.room_path(conn, :show, id))

      assert %{
               "address" => "satdobato",
               "available" => true,
               "district_name" => "Achham",
               "lat" => "27.7172",
               "long" => "85.3240",
               "number_of_rooms" => 1,
               "parking_count" => 0,
               "amenity_count" => 0,
               "price" => "3000"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.room_path(conn, :create), room: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "create room with parking  id should yeild parking_count" do
    test "renders room with parking_count when data is valid", %{conn: conn} do
      district = Finder.Districts.list_districts() |> Enum.at(0)
      parking = Finder.Parkings.list_parkings() |> Enum.at(0)
      attrs = %{@create_attrs | "district" => district.id}
      new_attrs = Map.put(attrs, :parkings, [parking.id])
      conn = post(conn, Routes.room_path(conn, :create), room: new_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]
      conn = get(conn, Routes.room_path(conn, :show, id))

      assert %{
               "address" => "satdobato",
               "available" => true,
               "district_name" => "Achham",
               "lat" => "27.7172",
               "long" => "85.3240",
               "number_of_rooms" => 1,
               "parking_count" => 1,
               "amenity_count" => 0,
               "price" => "3000"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.room_path(conn, :create), room: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "create room with amenity  id should yeild amenity_count" do
    test "renders room with amenity_count when data is valid", %{conn: conn} do
      district = Finder.Districts.list_districts() |> Enum.at(0)
      amenity = Finder.Amenities.list_amenities() |> Enum.at(0)
      attrs = %{@create_attrs | "district" => district.id}
      new_attrs = Map.put(attrs, :amenities, [amenity.id])
      conn = post(conn, Routes.room_path(conn, :create), room: new_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]
      conn = get(conn, Routes.room_path(conn, :show, id))

      assert %{
               "address" => "satdobato",
               "available" => true,
               "district_name" => "Achham",
               "lat" => "27.7172",
               "long" => "85.3240",
               "number_of_rooms" => 1,
               "parking_count" => 0,
               "amenity_count" => 1,
               "price" => "3000"
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
               "address" => "satdobato",
               "available" => true,
               "district_name" => "Achham",
               "lat" => "27.7172",
               "long" => "85.3240",
               "number_of_rooms" => 1,
               "price" => "3000"
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
      assert response(conn, 200)

      # assert_error_sent 404, fn ->
      #   get(conn, Routes.room_path(conn, :show, room))
      # end
      # json_response(conn, 422)["errors"]
      conn = delete(conn, Routes.room_path(conn, :delete, room))
      assert json_response(conn, 404)["errors"] != %{}
    end
  end

  defp create_room(_) do
    room = fixture(:room)
    %{room: room}
  end

  defp create_district(_) do
    district = fixture(:district)
    %{district: district}
  end
end
