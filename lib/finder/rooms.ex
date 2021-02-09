defmodule Finder.Rooms do
  @moduledoc """
  The Rooms context.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Finder.Repo

  alias Finder.Rooms.Room
  alias Finder.Parkings
  alias Finder.Amenities
  alias Finder.Images.Image

  @spec list_rooms :: nil | [%{optional(atom) => any}] | %{optional(atom) => any}
  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_rooms()
      [%Room{}, ...]

  """
  def list_rooms do
    # Post |> order_by(constraint) |> Repo.all()
    query =
      from r in Room,
        where: r.available == true,
        order_by: [desc: :inserted_at],
        preload: [:images]

    Repo.all(query)
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

  def get_preloaded_room_with(id) do
    get_room(id)
    |> Repo.preload([:amenities, :parkings, :images, :district, :user])
  end

  def get_image_preloaded_room_with(id) do
    get_room(id)
    |> Repo.preload([:images])
  end

  @doc """
  Creates a room.

  ## Examples

      iex> create_room(%{field: value})
      {:ok, %Room{}}

      iex> create_room(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_room(attrs \\ %{}, current_user) do
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
          |> put_assoc(:user, current_user)
          |> add_district_changes(district)
          |> Repo.insert()

        image_params = attrs["images"]

        associates =
          Enum.map(image_params, fn room_image ->
            image_changeset = Image.changeset(%Image{}, %{image: room_image})
            put_assoc(image_changeset, :room, room)
          end)

        insert_image(associates)
        room = get_image_preloaded_room_with(room.id)

        {:ok, room}
    end
  end

  def load_images(room) do
    Repo.preload(room, :images)
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

  # def update_room(%Room{} = room, attrs) do
  #   attrs = capitalize_address(attrs)
  #   changeset = Room.changeset(room, attrs)

  #   case changeset do
  #     %Ecto.Changeset{valid?: false} ->
  #       changeset
  #       |> apply_action(:insert)

  #     _ ->
  #       parkings = Parkings.get_parkings(attrs["parkings"])
  #       amenities = Amenities.get_amenities(attrs["amenities"])

  #       {:ok, room} =
  #         changeset
  #         |> put_assoc(:amenities, amenities)
  #         |> add_amenities_changes(amenities)
  #         |> put_assoc(:parkings, parkings)
  #         |> add_parking_changes(parkings)
  #         |> Repo.update()

  #       image_params = attrs["images"]

  #       images_ids = room.images |> Enum.map(fn e -> e.id end)
  #       query = from i in Image, where: i.id in ^images_ids
  #       Repo.delete_all(query)

  #       associates =
  #         Enum.map(image_params, fn room_image ->
  #           image_changeset = Image.changeset(%Image{}, %{image: room_image})
  #           put_assoc(image_changeset, :room, room)
  #         end)

  #       insert_image(associates)
  #       room = load_images(room)

  #       {:ok, room}
  #   end
  # end

  def update_room(%Room{} = room, attrs) do
    # attrs = capitalize_address(attrs)
    changeset = update_room_changeset(room, attrs)

    changeset =
      if attrs["parkings"] != nil do
        update_room_parking(changeset, attrs["parkings"])
      else
        changeset
      end

    changeset =
      if attrs["amenities"] != nil do
        update_room_amenities(changeset, attrs["amenities"])
      else
        changeset
      end

    {:ok, room} =
      changeset
      |> Repo.update()

    if(attrs["images"] != nil) do
      update_room_image(room, attrs["images"])
    else
      {:ok, room}
    end

    room = get_preloaded_room_with(room.id)
    {:ok, room}
  end

  defp update_room_amenities(changeset, amenities_param) do
    amenities = Amenities.get_amenities(amenities_param)

    changeset
    |> put_assoc(:amenities, amenities)
    |> add_amenities_changes(amenities)
  end

  defp update_room_parking(changeset, parkings_params) do
    parkings = Parkings.get_parkings(parkings_params)

    changeset
    |> put_assoc(:parkings, parkings)
    |> add_parking_changes(parkings)
  end

  defp update_room_image(room, image_params) do
    images_ids = room.images |> Enum.map(fn e -> e.id end)
    query = from i in Image, where: i.id in ^images_ids
    Repo.delete_all(query)

    associates =
      Enum.map(image_params, fn room_image ->
        image_changeset = Image.changeset(%Image{}, %{image: room_image})
        put_assoc(image_changeset, :room, room)
      end)

    insert_image(associates)
  end

  def capitalize_address(attrs) do
    address = attrs["address"]

    case address do
      nil ->
        attrs

      result ->
        new_address = result |> String.trim() |> String.capitalize()
        Map.put(attrs, "address", new_address)
    end
  end

  def my_rooms(user) do
    query =
      from r in Room,
        where: r.user_id == ^user.id,
        order_by: [desc: :inserted_at],
        preload: [:images, :amenities, :parkings, :district, :user]

    Repo.all(query)
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

  def update_room_changeset(%Room{} = room, attrs \\ %{}) do
    Room.update_changeset(room, attrs)
  end

  def water_types do
    [
      %WaterTypes{name: "24/7", value: 0},
      %WaterTypes{name: "Enough for small family", value: 1},
      %WaterTypes{name: "Enough for small family", value: 2}
    ]
  end

  def room_types do
    [
      %RoomTypes{name: "Appartment", value: 0},
      %RoomTypes{name: "Room", value: 1},
      %RoomTypes{name: "Flat", value: 2},
      %RoomTypes{name: "Hostel", value: 3},
      %RoomTypes{name: "Shutter", value: 4},
      %RoomTypes{name: "Office", value: 5},
      %RoomTypes{name: "Commercial", value: 5}
    ]
  end

  def get_water_type_by_id(id) do
    Enum.find(water_types(), &(&1.value == id))
  end

  def get_room_type_by_id(id) do
    Enum.find(room_types(), &(&1.value == id))
  end
end
