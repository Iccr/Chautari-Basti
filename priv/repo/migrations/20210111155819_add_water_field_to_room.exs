defmodule Finder.Repo.Migrations.AddWaterFieldToRoom do
  use Ecto.Migration

  def change do
    alter table :rooms do
      add :water, :integer
    end
  end
end
