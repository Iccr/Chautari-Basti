defmodule Finder.Repo.Migrations.AddFieldsToUser do
  use Ecto.Migration

  def change do
    alter table :users do
      add :fuid, :string, null: false
      add :fcm, :string, null: false
    end

  end
end
