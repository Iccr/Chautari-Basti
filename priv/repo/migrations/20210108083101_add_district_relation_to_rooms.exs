defmodule Finder.Repo.Migrations.AddDistrictRelationToRooms do
  use Ecto.Migration

  def change do
    alter table :rooms do
      add :district_id, references( :districts, on_delete: :delete_all)
    end
  end
end
