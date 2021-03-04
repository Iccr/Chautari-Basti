defmodule Finder.Repo.Migrations.ChangeFcmTypFromUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do

      modify :fcm, :text, from: :string
      modify :token, :text, from: :string
      modify :fuid, :text, from: :string, null: true
    end
  end
end
