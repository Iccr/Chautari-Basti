defmodule Finder.Repo.Migrations.AddFieldsToUser do
  use Ecto.Migration

  def change do
    alter table :users do
      add :fuid, :string
      add :fcm, :string
    end

  end
end
