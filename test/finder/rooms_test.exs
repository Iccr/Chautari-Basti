defmodule Finder.RoomsTest do
  use Finder.DataCase

  alias Finder.Rooms

  describe "rooms" do
    alias Finder.Rooms.Room

    @valid_attrs %{address: "some address", lat: "120.5", long: "120.5", number_of_rooms: 42, price: "120.5"}
    @update_attrs %{address: "some updated address", lat: "456.7", long: "456.7", number_of_rooms: 43, price: "456.7"}
    @invalid_attrs %{address: nil, lat: nil, long: nil, number_of_rooms: nil, price: nil}

    def room_fixture(attrs \\ %{}) do
      {:ok, room} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Rooms.create_room()

      room
    end

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Rooms.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Rooms.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      assert {:ok, %Room{} = room} = Rooms.create_room(@valid_attrs)
      assert room.address == "some address"
      assert room.lat == Decimal.new("120.5")
      assert room.long == Decimal.new("120.5")
      assert room.number_of_rooms == 42
      assert room.price == Decimal.new("120.5")
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      assert {:ok, %Room{} = room} = Rooms.update_room(room, @update_attrs)
      assert room.address == "some updated address"
      assert room.lat == Decimal.new("456.7")
      assert room.long == Decimal.new("456.7")
      assert room.number_of_rooms == 43
      assert room.price == Decimal.new("456.7")
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
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
