defmodule Finder.Repo.Migrations.CreateParkings do
  use Ecto.Migration

  def change do
    create table(:parkings) do
      add :name, :string
      add :tag, :integer

      timestamps()
    end

    create unique_index(:parkings, [:name])

  end
end
