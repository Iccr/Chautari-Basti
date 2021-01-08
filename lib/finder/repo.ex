defmodule Finder.Repo do
  use Ecto.Repo,
    otp_app: :finder,
    adapter: Ecto.Adapters.Postgres
end
