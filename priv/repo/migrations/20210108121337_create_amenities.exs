defmodule Finder.Repo.Migrations.CreateAmenities do
  use Ecto.Migration

  def change do
    create table(:amenities) do
      add :name, :string
      add :tag, :integer

      timestamps()
    end

  end
end
