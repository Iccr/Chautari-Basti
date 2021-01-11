defmodule Finder.Amenities do
  @moduledoc """
  The Amenities context.
  """

  import Ecto.Query, warn: false
  alias Finder.Repo

  alias Finder.Amenities.Amenity

  @doc """
  Returns the list of amenities.

  ## Examples

      iex> list_amenities()
      [%Amenity{}, ...]

  """
  def list_amenities do
    Repo.all(Amenity)
  end

  @doc """
  Gets a single amenity.

  Raises `Ecto.NoResultsError` if the Amenity does not exist.

  ## Examples

      iex> get_amenity!(123)
      %Amenity{}

      iex> get_amenity!(456)
      ** (Ecto.NoResultsError)

  """
  def get_amenity!(id), do: Repo.get!(Amenity, id)

  @doc """
  Creates a amenity.

  ## Examples

      iex> create_amenity(%{field: value})
      {:ok, %Amenity{}}

      iex> create_amenity(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_amenity(attrs \\ %{}) do
    %Amenity{}
    |> Amenity.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a amenity.

  ## Examples

      iex> update_amenity(amenity, %{field: new_value})
      {:ok, %Amenity{}}

      iex> update_amenity(amenity, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_amenity(%Amenity{} = amenity, attrs) do
    amenity
    |> Amenity.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a amenity.

  ## Examples

      iex> delete_amenity(amenity)
      {:ok, %Amenity{}}

      iex> delete_amenity(amenity)
      {:error, %Ecto.Changeset{}}

  """
  def delete_amenity(%Amenity{} = amenity) do
    Repo.delete(amenity)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking amenity changes.

  ## Examples

      iex> change_amenity(amenity)
      %Ecto.Changeset{data: %Amenity{}}

  """
  def change_amenity(%Amenity{} = amenity, attrs \\ %{}) do
    Amenity.changeset(amenity, attrs)
  end

  def get_amenities(nil), do: []

  def get_amenities(ids) do
    Repo.all(from a in Amenity, where: a.id in ^ids)
  end
end
