defmodule FinderWeb.RoomController do
  use FinderWeb, :controller

  alias Finder.Rooms
  alias Finder.Rooms.Room

  action_fallback FinderWeb.FallbackController

  def index(conn, _params) do
    rooms = Rooms.list_rooms()
    render(conn, "index.json", rooms: rooms)
  end

  def create(conn, %{"room" => room_params}) do
    with {:ok, %Room{} = room} <- Rooms.create_room(room_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.room_path(conn, :show, room))
      |> render("show.json", room: room)
    end
  end

  def show(conn, %{"id" => id}) do
    case Rooms.get_room(id) do
      nil ->
        {:error, :not_found}

      room ->
        render(conn, "show.json", room: room)
    end
  end

  def update(conn, %{"id" => id, "room" => room_params}) do
    case Rooms.get_room(id) do
      nil ->
        {:error, :not_found}

      room ->
        with {:ok, %Room{} = room} <- Rooms.update_room(room, room_params) do
          render(conn, "show.json", room: room)
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    case Rooms.get_room(id) do
      nil ->
        {:error, :not_found}

      room ->
        with {:ok, %Room{}} <- Rooms.delete_room(room) do
          render(conn, "show.json", room: room)
        end
    end
  end
end
