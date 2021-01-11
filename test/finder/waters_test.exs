defmodule Finder.WatersTest do
  use Finder.DataCase

  alias Finder.Waters

  describe "waters" do
    alias Finder.Waters.Water

    @valid_attrs %{name: "some name", tag: 42}
    @update_attrs %{name: "some updated name", tag: 43}
    @invalid_attrs %{name: nil, tag: nil}

    def water_fixture(attrs \\ %{}) do
      {:ok, water} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Waters.create_water()

      water
    end

    test "list_waters/0 returns all waters" do
      water = water_fixture()
      assert Waters.list_waters() != []
    end

    test "get_water!/1 returns the water with given id" do
      water = water_fixture()
      assert Waters.get_water!(water.id) == water
    end

    test "create_water/1 with valid data creates a water" do
      assert {:ok, %Water{} = water} = Waters.create_water(@valid_attrs)
      assert water.name == "some name"
      assert water.tag == 42
    end

    test "create_water/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Waters.create_water(@invalid_attrs)
    end

    test "update_water/2 with valid data updates the water" do
      water = water_fixture()
      assert {:ok, %Water{} = water} = Waters.update_water(water, @update_attrs)
      assert water.name == "some updated name"
      assert water.tag == 43
    end

    test "update_water/2 with invalid data returns error changeset" do
      water = water_fixture()
      assert {:error, %Ecto.Changeset{}} = Waters.update_water(water, @invalid_attrs)
      assert water == Waters.get_water!(water.id)
    end

    test "delete_water/1 deletes the water" do
      water = water_fixture()
      assert {:ok, %Water{}} = Waters.delete_water(water)
      assert_raise Ecto.NoResultsError, fn -> Waters.get_water!(water.id) end
    end

    test "change_water/1 returns a water changeset" do
      water = water_fixture()
      assert %Ecto.Changeset{} = Waters.change_water(water)
    end
  end
end
