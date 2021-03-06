defmodule Finder.ParkingsTest do
  use Finder.DataCase

  alias Finder.Parkings

  describe "parkings" do
    alias Finder.Parkings.Parking

    @valid_attrs %{name: "some name", tag: 42}
    @update_attrs %{name: "some updated name", tag: 43}
    @invalid_attrs %{name: nil, tag: nil}

    def parking_fixture(attrs \\ %{}) do
      {:ok, parking} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Parkings.create_parking()

      parking
    end

    test "list_parkings/0 returns all parkings" do
      parking = parking_fixture()
      assert Parkings.list_parkings() != []
    end

    test "get_parking!/1 returns the parking with given id" do
      parking = parking_fixture()
      assert Parkings.get_parking!(parking.id) == parking
    end

    test "create_parking/1 with valid data creates a parking" do
      assert {:ok, %Parking{} = parking} = Parkings.create_parking(@valid_attrs)
      assert parking.name == "some name"
      assert parking.tag == 42
    end

    test "create_parking/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Parkings.create_parking(@invalid_attrs)
    end

    test "update_parking/2 with valid data updates the parking" do
      parking = parking_fixture()
      assert {:ok, %Parking{} = parking} = Parkings.update_parking(parking, @update_attrs)
      assert parking.name == "some updated name"
      assert parking.tag == 43
    end

    test "update_parking/2 with invalid data returns error changeset" do
      parking = parking_fixture()
      assert {:error, %Ecto.Changeset{}} = Parkings.update_parking(parking, @invalid_attrs)
      assert parking == Parkings.get_parking!(parking.id)
    end

    test "delete_parking/1 deletes the parking" do
      parking = parking_fixture()
      assert {:ok, %Parking{}} = Parkings.delete_parking(parking)
      assert_raise Ecto.NoResultsError, fn -> Parkings.get_parking!(parking.id) end
    end

    test "change_parking/1 returns a parking changeset" do
      parking = parking_fixture()
      assert %Ecto.Changeset{} = Parkings.change_parking(parking)
    end

    test "get_parkinngs_in_list" do
      params1 = %{name: "bike", tag: 42}
      params2 = %{name: "car", tag: 43}
      params3 = %{name: "sumo", tag: 44}
      create_parking_with_attrs(params1)
      create_parking_with_attrs(params2)
      create_parking_with_attrs(params3)
      parkings = Parkings.list_parkings()

      ids = Enum.map(parkings, fn x -> x.id end)

      results = Parkings.get_parkings(ids)
      result_ids = Enum.map(results, fn x -> x.id end)

      assert result_ids == ids
    end

    def create_parking_with_attrs(params) do
      %{}
      |> Enum.into(params)
      |> Parkings.create_parking()
    end
  end
end
