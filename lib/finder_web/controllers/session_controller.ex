defmodule FinderWeb.SessionController do
  use FinderWeb, :controller
  alias Finder.Accounts

  alias Finder.Guardian

  def login(conn, %{"user" => user_params}) do
    user = get_user_with_email_token(user_params)

    if user do
      with {:ok, token, _claims} <- sign(user) do
        user = Map.put(user, :auth_token, token)
        show_user(conn, user)
      end
    else
      case verify_token(user_params) do
        {:ok, name} ->
          user_params = Map.put(user_params, "name", name)

          with {:ok, user} = Accounts.create_user(user_params),
               {:ok, token, _claims} <- sign(user) do
            user = Map.put(user, :auth_token, token)
            show_user(conn, user)
          else
            {:error, message} ->
              show_error(conn, message)
          end

        {:error, message} ->
          show_error(conn, message)
      end
    end
  end

  def verify_token(attrs) do
    token = attrs["token"]
    url = "https://graph.facebook.com/me?access_token=" <> token

    result =
      Task.async(fn -> HTTPoison.get(url) end)
      |> Task.await()
      |> Jason.decode()

    case result do
      {:ok, %{"error" => %{"message" => message}}} ->
        {:error, message}

      {:ok, %{"name" => name}} ->
        {:ok, name}

      {:error, _} ->
        IO.puts("error")
        {:error, "not allowed"}
    end
  end

  def show_error(conn, message) do
    conn
    |> put_view(FinderWeb.ErrorView)
    |> render("error.json", message: message)
  end

  def sign(user) do
    Guardian.encode_and_sign(user)
  end

  def get_user_with_email_token(%{"email" => email, "token" => token}) do
    Accounts.get_user_with_email_token(email, token)
  end

  def get_user_with_email_token(%{"token" => token}) do
    Accounts.get_user_with_email_token(nil, token)
  end

  def show_user(conn, user) do
    conn
    |> put_view(FinderWeb.UserView)
    |> render("show.json", user: user)
  end
end
