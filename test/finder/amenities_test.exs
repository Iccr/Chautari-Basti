defmodule Finder.AmenitiesTest do
  use Finder.DataCase

  alias Finder.Amenities

  describe "amenities" do
    alias Finder.Amenities.Amenity

    @valid_attrs %{name: "some name", tag: 42}
    @update_attrs %{name: "some updated name", tag: 43}
    @invalid_attrs %{name: nil, tag: nil}

    def amenity_fixture(attrs \\ %{}) do
      {:ok, amenity} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Amenities.create_amenity()

      amenity
    end

    test "list_amenities/0 returns all amenities" do
      amenity = amenity_fixture()
      assert Amenities.list_amenities() == [amenity]
    end

    test "get_amenity!/1 returns the amenity with given id" do
      amenity = amenity_fixture()
      assert Amenities.get_amenity!(amenity.id) == amenity
    end

    test "create_amenity/1 with valid data creates a amenity" do
      assert {:ok, %Amenity{} = amenity} = Amenities.create_amenity(@valid_attrs)
      assert amenity.name == "some name"
      assert amenity.tag == 42
    end

    test "create_amenity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Amenities.create_amenity(@invalid_attrs)
    end

    test "update_amenity/2 with valid data updates the amenity" do
      amenity = amenity_fixture()
      assert {:ok, %Amenity{} = amenity} = Amenities.update_amenity(amenity, @update_attrs)
      assert amenity.name == "some updated name"
      assert amenity.tag == 43
    end

    test "update_amenity/2 with invalid data returns error changeset" do
      amenity = amenity_fixture()
      assert {:error, %Ecto.Changeset{}} = Amenities.update_amenity(amenity, @invalid_attrs)
      assert amenity == Amenities.get_amenity!(amenity.id)
    end

    test "delete_amenity/1 deletes the amenity" do
      amenity = amenity_fixture()
      assert {:ok, %Amenity{}} = Amenities.delete_amenity(amenity)
      assert_raise Ecto.NoResultsError, fn -> Amenities.get_amenity!(amenity.id) end
    end

    test "change_amenity/1 returns a amenity changeset" do
      amenity = amenity_fixture()
      assert %Ecto.Changeset{} = Amenities.change_amenity(amenity)
    end
  end
end
