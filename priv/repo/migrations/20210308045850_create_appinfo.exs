defmodule Finder.Repo.Migrations.CreateAppinfo do
  use Ecto.Migration

  def change do
    create table(:appinfo) do
      add :android_version, :string
      add :ios_version, :string
      add :app_key, :string
      add :force_update, :string

      timestamps()
    end

  end
end
