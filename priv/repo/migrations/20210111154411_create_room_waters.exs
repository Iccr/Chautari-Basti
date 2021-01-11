defmodule Finder.Repo.Migrations.CreateRoomWaters do
  use Ecto.Migration

  def change do
    create table(:room_waters) do
      add :room_id, references(:rooms, on_delete: :delete_all)
      add :water_id, references(:waters, on_delete: :delete_all)

      timestamps()
    end

    create index(:room_waters, [:room_id])
    create index(:room_waters, [:water_id])
  end
end
