defmodule FinderWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  # channel "room:*", FinderWeb.RoomChannel

  channel "rent_room:*", FinderWeb.RentRoomChannel
  channel "user_room:*", FinderWeb.RentRoomChannel

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.

  @impl true
  def connect(%{"token" => token}, socket) do
    case Guardian.Phoenix.Socket.authenticate(socket, Finder.Guardian, token) do
      {:ok, authed_socket} ->
        {:ok, authed_socket}

      {:error, _} ->
        :error
    end
  end

  @impl true
  # def connect(_params, _socket, _connect_info) do
  #   IO.puts("FAILED")
  #   :error
  # end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     FinderWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  @impl true
  def id(_socket), do: nil
end
