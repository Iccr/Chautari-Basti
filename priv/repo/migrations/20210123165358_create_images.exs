defmodule Finder.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :image, :string
      add :room_id, references( :rooms, on_delete: :delete_all)

      timestamps()
    end

  end
end
