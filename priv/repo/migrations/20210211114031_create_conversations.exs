defmodule Finder.Repo.Migrations.CreateConversations do
  use Ecto.Migration

  def change do
    create table(:conversations) do
      add :sender_id, references(:users, on_delete: :nothing)
      add :recipient_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:conversations, [:sender_id])
    create index(:conversations, [:recipient_id])
    create unique_index(:conversations, [:sender_id, :recipient_id], name: :sender)
  end
end
