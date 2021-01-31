defmodule Finder.Repo.Migrations.AddRoomRelationWithUsers do
  use Ecto.Migration

  def change do
    alter table :rooms do
      add :user_id, references(:users, on_delete: :delete_all)
    end
  end
end
