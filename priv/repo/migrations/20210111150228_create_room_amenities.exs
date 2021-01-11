defmodule Finder.Repo.Migrations.CreateRoomAmenities do
  use Ecto.Migration

  def change do
    create table(:room_amenities) do
      add :room_id, references(:rooms, on_delete: :delete_all)
      add :amenity_id, references(:amenities, on_delete: :delete_all)

      timestamps()
    end

    create index(:room_amenities, [:room_id])
    create index(:room_amenities, [:amenity_id])
  end
end
