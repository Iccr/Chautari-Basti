defmodule Finder.Repo.Migrations.CreateRoomParkings do
  use Ecto.Migration

  def change do
    create table(:room_parkings) do
      add :room_id, references(:rooms, on_delete: :delete_all)
      add :parking_id, references(:parkings, on_delete: :delete_all)

      timestamps()
    end

    create index(:room_parkings, [:room_id])
    create index(:room_parkings, [:parking_id])
  end
end
