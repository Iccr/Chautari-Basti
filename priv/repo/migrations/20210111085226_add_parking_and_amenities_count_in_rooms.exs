defmodule Finder.Repo.Migrations.AddParkingAndAmenitiesCountInRooms do
  use Ecto.Migration

  def change do
    alter table "rooms" do
      add :parking_count, :integer, default: 0
      add :amenity_count, :integer, default: 0
    end
  end
end
