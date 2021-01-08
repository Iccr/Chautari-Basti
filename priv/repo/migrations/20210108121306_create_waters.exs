defmodule Finder.Repo.Migrations.CreateWaters do
  use Ecto.Migration

  def change do
    create table(:waters) do
      add :name, :string
      add :tag, :integer

      timestamps()
    end

  end
end
