defmodule Finder.Repo.Migrations.AddOccupiedToRooms do
  use Ecto.Migration

  def change do
    alter table("rooms") do
      add :available, :boolean, default: true
    end
  end
end
