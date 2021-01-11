defmodule Finder.RoomsTest do
  use Finder.DataCase

  alias Finder.Rooms

  describe "rooms" do
    alias Finder.Rooms.Room

    alias Finder.Parkings
    alias Finder.Parkings.Parking
    alias Finder.Amenities

    @valid_attrs %{name: "Bike", tag: 46}

    @valid_attrs %{
      "address" => "satdobato",
      "available" => true,
      "district" => 2,
      "parkings" => [1],
      "lat" => "27.7172",
      "long" => "85.3240",
      "number_of_rooms" => "1",
      "price" => "3000"
    }

    @valid_attrs_with_parkings %{
      "address" => "satdobato",
      "available" => true,
      "district" => 2,
      "parkings" => [1],
      "lat" => "27.7172",
      "long" => "85.3240",
      "number_of_rooms" => "1",
      "price" => "3000"
    }

    @valid_attrs_with_amenities %{
      "address" => "satdobato",
      "available" => true,
      "district" => 2,
      "parkings" => [1],
      "aminities" => [1, 2],
      "lat" => "27.7172",
      "long" => "85.3240",
      "number_of_rooms" => "1",
      "price" => "3000"
    }

    @update_attrs %{
      address: "some updated address",
      lat: "456.7",
      long: "456.7",
      number_of_rooms: 43,
      available: false,
      price: "456.7"
    }
    @invalid_attrs %{address: nil, lat: nil, long: nil, number_of_rooms: nil, price: nil}

    def room_fixture(attrs \\ %{}) do
      {:ok, room} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Rooms.create_room()

      room
    end

    def parking_fixture(attrs \\ %{}) do
      {:ok, parking} =
        attrs
        |> Enum.into(@valid_attrs_with_parkings)
        |> Parkings.create_parking()

      parking
    end

    def amenities_fixture(attrs \\ %{}) do
      {:ok, amenity} =
        attrs
        |> Enum.into(@valid_attrs_with_parkings)
        |> Amenities.create_amenity()

      amenity
    end

    test "list_rooms/0 returns all rooms" do
      r = room_fixture()
      room = Rooms.get_room!(r.id)
      assert Rooms.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      r = room_fixture()
      room = Rooms.get_room!(r.id)
      assert Rooms.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      assert {:ok, %Room{} = room} = Rooms.create_room(@valid_attrs)
      assert room.address == "satdobato"
      assert room.available == true
      assert room.district_name == "Arghakhanchi"
      assert room.lat == Decimal.new("27.7172")
      assert room.long == Decimal.new("85.3240")
      assert room.number_of_rooms == 1
      assert room.price == Decimal.new("3000")
    end

    test "create_room/1 with valid parkings data creates a room with parkings" do
      Parkings.create_parking(@valid_attrs_with_parkings)
      parking = Parkings.get_parking!(1)
      map = %{@valid_attrs | "parkings" => [parking.id]}
      assert {:ok, %Room{} = room} = Rooms.create_room(map)

      assert room.address == "satdobato"
      assert room.parking_count == 1
      assert room.available == true
      assert room.district_name == "Arghakhanchi"
      assert room.lat == Decimal.new("27.7172")
      assert room.long == Decimal.new("85.3240")
      assert room.number_of_rooms == 1
      assert room.price == Decimal.new("3000")
    end

    test "create_room/1 with valid amenities data creates a room with amenities" do
      Amenities.create_amenity(@valid_attrs_with_amenities)
      amenity = Amenities.list_amenities() |> Enum.at(0)
      map = %{@valid_attrs | "amenities" => [amenity.id]}
      assert {:ok, %Room{} = room} = Rooms.create_room(map)

      assert room.address == "satdobato"
      assert room.amenity_count == 1
      assert room.available == true
      assert room.district_name == "Arghakhanchi"
      assert room.lat == Decimal.new("27.7172")
      assert room.long == Decimal.new("85.3240")
      assert room.number_of_rooms == 1
      assert room.price == Decimal.new("3000")
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      assert {:ok, %Room{} = room} = Rooms.update_room(room, @update_attrs)
      assert room.address == "some updated address"
      assert room.available == false
      assert room.lat == Decimal.new("456.7")
      assert room.long == Decimal.new("456.7")
      assert room.number_of_rooms == 43
      assert room.price == Decimal.new("456.7")
    end

    test "update_room/2 with invalid data returns error changeset" do
      r = room_fixture()
      room = Rooms.get_room!(r.id)
      assert {:error, %Ecto.Changeset{}} = Rooms.update_room(room, @invalid_attrs)
      assert room == Rooms.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Rooms.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Rooms.change_room(room)
    end
  end
end
