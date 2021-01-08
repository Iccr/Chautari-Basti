defmodule Finder.Waters do
  @moduledoc """
  The Waters context.
  """

  import Ecto.Query, warn: false
  alias Finder.Repo

  alias Finder.Waters.Water

  @doc """
  Returns the list of waters.

  ## Examples

      iex> list_waters()
      [%Water{}, ...]

  """
  def list_waters do
    Repo.all(Water)
  end

  @doc """
  Gets a single water.

  Raises `Ecto.NoResultsError` if the Water does not exist.

  ## Examples

      iex> get_water!(123)
      %Water{}

      iex> get_water!(456)
      ** (Ecto.NoResultsError)

  """
  def get_water!(id), do: Repo.get!(Water, id)

  @doc """
  Creates a water.

  ## Examples

      iex> create_water(%{field: value})
      {:ok, %Water{}}

      iex> create_water(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_water(attrs \\ %{}) do
    %Water{}
    |> Water.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a water.

  ## Examples

      iex> update_water(water, %{field: new_value})
      {:ok, %Water{}}

      iex> update_water(water, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_water(%Water{} = water, attrs) do
    water
    |> Water.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a water.

  ## Examples

      iex> delete_water(water)
      {:ok, %Water{}}

      iex> delete_water(water)
      {:error, %Ecto.Changeset{}}

  """
  def delete_water(%Water{} = water) do
    Repo.delete(water)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking water changes.

  ## Examples

      iex> change_water(water)
      %Ecto.Changeset{data: %Water{}}

  """
  def change_water(%Water{} = water, attrs \\ %{}) do
    Water.changeset(water, attrs)
  end
end
