defmodule Finder.AuthErrorHandler do
  import Plug.Conn

  def auth_error(conn, {_type, _reason}, _opts) do
    body = Jason.encode!(%{errors: [%{name: "authorization", value: "authorization failed"}]})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, body)
  end
end
