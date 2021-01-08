defmodule Finder.Repo.Migrations.CreateDistricts do
  use Ecto.Migration

  def change do
    create table(:districts) do
      add :state, :integer
      add :name, :string

      timestamps()
    end
    create unique_index(:districts, [:name])
  end
end
