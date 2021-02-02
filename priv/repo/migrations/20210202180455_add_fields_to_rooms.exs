defmodule Finder.Repo.Migrations.AddFieldsToRooms do
  use Ecto.Migration

  def change do
    alter table :rooms do
      add :type, :integer
      add :phone, :string
      add :phone_visibility, :boolean, default: true
    end
  end
end
