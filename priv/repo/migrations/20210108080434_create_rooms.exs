defmodule Finder.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :lat, :decimal
      add :long, :decimal
      add :address, :string
      add :price, :decimal
      add :number_of_rooms, :integer

      timestamps()
    end

  end
end
