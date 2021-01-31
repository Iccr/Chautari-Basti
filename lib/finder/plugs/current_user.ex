defmodule Finder.Plugs.CurrentUser do
  def init(opts), do: opts

  def call(conn, _opts) do
    current_token = Guardian.Plug.current_token(conn)

    case Finder.Guardian.resource_from_token(current_token) do
      {:ok, user, _claims} ->
        Plug.Conn.assign(conn, :current_user, user)

      {:error, _reason} ->
        IO.puts("ioioioio")
        conn
    end
  end
end
