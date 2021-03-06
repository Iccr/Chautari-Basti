defmodule Finder.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Finder.Repo

  alias Finder.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def get_user_with_email_token(incoming_email, incoming_token) do
    email = if is_nil(incoming_email), do: "", else: incoming_email
    token = if is_nil(incoming_token), do: "", else: incoming_token

    query = from user in User, where: user.email == ^email or user.token == ^token

    query
    |> Repo.all()
    |> Enum.at(0)
  end

  def get_user_with_token(token) do
    query = from user in User, where: user.token == ^token

    query
    |> Repo.one()
  end

  def get_user_with_email(email) do
    query = from user in User, where: user.email == ^email

    query
    |> Repo.one()
  end

  def get_user_with_uid(uid) do
    query = from user in User, where: user.fuid == ^uid

    query
    |> Repo.one()
  end

  def load_my_rooms(current_user) do
    current_user
    |> Repo.preload(rooms: {:images, :amenities, :parkings, :district})
  end
end
