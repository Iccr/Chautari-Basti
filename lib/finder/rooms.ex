defmodule Finder.Rooms do
  @moduledoc """
  The Rooms context.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Finder.Repo

  alias Finder.Rooms.Room
  alias Finder.Districts.District
  alias Finder.Parkings
  alias Finder.Amenities
  alias Finder.Images.Image

  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_rooms()
      [%Room{}, ...]

  """
  def list_rooms do
    Repo.all(Room)
  end

  @doc """
  Gets a single room.

  Raises `Ecto.NoResultsError` if the Room does not exist.

  ## Examples

      iex> get_room!(123)
      %Room{}

      iex> get_room!(456)
      ** (Ecto.NoResultsError)

  """
  def get_room!(id), do: Repo.get!(Room, id)

  def get_room(id), do: Repo.get(Room, id)

  @doc """
  Creates a room.

  ## Examples

      iex> create_room(%{field: value})
      {:ok, %Room{}}

      iex> create_room(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_room(attrs \\ %{}) do
    changeset = Room.changeset(%Room{}, attrs)

    case changeset do
      %Ecto.Changeset{valid?: false} ->
        changeset
        |> apply_action(:insert)

      _ ->
        district = Finder.Districts.get_district!(attrs["district"])

        parkings = Parkings.get_parkings(attrs["parkings"])
        amenities = Amenities.get_amenities(attrs["amenities"])

        {:ok, room} =
          changeset
          |> put_assoc(:amenities, amenities)
          |> add_amenities_changes(amenities)
          |> put_assoc(:parkings, parkings)
          |> add_parking_changes(parkings)
          |> put_assoc(:district, district)
          |> add_district_changes(district)
          |> Repo.insert()

        image_params = attrs["images"]
        IO.inspect(image_params)

        associates =
          Enum.map(image_params, fn room_image ->
            image_changeset = Image.changeset(%Image{}, %{image: room_image})
            put_assoc(image_changeset, :room, room)
          end)

        insert_image(associates)
        room = Repo.preload(room, :images)

        {:ok, room}
    end
  end

  def insert_image([head | tail]) do
    Repo.insert(head)
    insert_image(tail)
  end

  def insert_image([]) do
    []
  end

  defp add_amenities_changes(changeset, amenities) do
    put_change(changeset, :amenity_count, Enum.count(amenities))
  end

  defp add_parking_changes(changeset, parkings) do
    put_change(changeset, :parking_count, Enum.count(parkings))
  end

  defp add_district_changes(changeset, district) do
    changeset
    |> put_change(:state, district.state)
    |> put_change(:district_name, district.name)
  end

  @doc """
  Updates a room.

  ## Examples

      iex> update_room(room, %{field: new_value})
      {:ok, %Room{}}

      iex> update_room(room, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_room(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a room.

  ## Examples

      iex> delete_room(room)
      {:ok, %Room{}}

      iex> delete_room(room)
      {:error, %Ecto.Changeset{}}

  """
  def delete_room(%Room{} = room) do
    Repo.delete(room)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking room changes.

  ## Examples

      iex> change_room(room)
      %Ecto.Changeset{data: %Room{}}

  """
  def change_room(%Room{} = room, attrs \\ %{}) do
    Room.changeset(room, attrs)
  end

  def water_types do
    [
      %WaterTypes{name: "24/7", value: 0},
      %WaterTypes{name: "Enough for small family", value: 1},
      %WaterTypes{name: "Enough for small family", value: 2}
    ]
  end

  def get_water_type_by_id(id) do
    Enum.find(water_types(), &(&1.value == id))
  end
end
