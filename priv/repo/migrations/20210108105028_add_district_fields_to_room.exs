defmodule Finder.Repo.Migrations.AddDistrictFieldsToRoom do
  use Ecto.Migration

  def change do
    alter table("rooms") do
      add :state, :integer
      add :district_name, :string
    end
  end
end
