defmodule Finder.Parkings.Parking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "parkings" do
    field :name, :string
    field :tag, :integer

    timestamps()
  end

  @doc false
  def changeset(parking, attrs) do
    parking
    |> cast(attrs, [:name, :tag])
    |> validate_required([:name, :tag])
    |> unique_constraint(:name)
  end
end
