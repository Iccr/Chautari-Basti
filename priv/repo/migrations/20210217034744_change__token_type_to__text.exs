defmodule Finder.Repo.Migrations.Change_TokenTypeTo_Text do
  use Ecto.Migration

  def change do
alter table :users do
  modify :token, :text
end
  end
end
