defmodule FinderWeb.RoomController do
  use FinderWeb, :controller

  alias Finder.Rooms
  alias Finder.Rooms.Room

  action_fallback FinderWeb.FallbackController

  plug Finder.Guardian.ProtectedPipeline when action in [:create, :update, :delete]
  plug Finder.Plugs.CurrentUser when action in [:create, :update, :delete]

  def index(conn, _params) do
    rooms = Rooms.list_rooms()
    render(conn, "index.json", rooms: rooms)
  end

  def create(conn, room_params) do
    current_user = conn.assigns.current_user

    with {:ok, %Room{} = room} <- Rooms.create_room(room_params, current_user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.room_path(conn, :show, room))
      |> render("show.json", room: room)
    end
  end

  def show(conn, %{"id" => id}) do
    case Rooms.get_preloaded_room_with(id) do
      nil ->
        {:error, :not_found}

      room ->
        IO.inspect(room)
        render(conn, "show.json", room: room)
    end
  end

  def update(conn, %{"id" => id} = room_params) do
    case Rooms.get_preloaded_room_with(id) do
      nil ->
        {:error, :not_found}

      room ->
        with {:ok, %Room{} = room} <- Rooms.update_room(room, room_params) do
          room = Rooms.load_images(room)
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
