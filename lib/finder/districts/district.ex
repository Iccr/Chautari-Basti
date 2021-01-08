defmodule Finder.Districts.District do
  use Ecto.Schema
  import Ecto.Changeset

  schema "districts" do
    field :name, :string
    field :state, :integer
    has_many :rooms, Finder.Rooms.Room
    timestamps()
  end

  @doc false
  def changeset(district, attrs) do
    district
    |> cast(attrs, [:state, :name])
    |> validate_required([:state, :name])
    |> unique_constraint(:name)
  end
end
