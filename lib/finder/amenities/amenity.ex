defmodule Finder.Amenities.Amenity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "amenities" do
    field :name, :string
    field :tag, :integer

    timestamps()
  end

  @doc false
  def changeset(amenity, attrs) do
    amenity
    |> cast(attrs, [:name, :tag])
    |> validate_required([:name, :tag])
  end
end
