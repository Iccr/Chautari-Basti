defmodule Finder.AuthErrorHandler do
  import Plug.Conn

  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!(%{error: "unauthorized"})
    send_resp(conn, 401, body)
  end
end
