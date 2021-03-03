defmodule FinderWeb.SessionController do
  use FinderWeb, :controller
  alias Finder.Accounts

  alias Finder.Guardian

  @spec login(any, map) :: {:error, any} | Plug.Conn.t()
  def login(conn, %{"user" => user_params}) do
    case Finder.SocialSession.verify_token(user_params) do
      {:error, message} ->
        show_error(conn, message)

      {:ok, name, email} ->
        user_id = user_params["user_id"]
        user = find_user(user_params, email)

        if(user) do
          sign_in_and_render(conn, user)
        else
          params = Map.put(user_params, "name", name)
          params = Map.put(params, "email", email)
          params = Map.put(params, "fuid", user_id)
          IO.inspect(params)

          case create_user(params) do
            {:ok, user} ->
              {:ok, token, _claims} = sign(user)
              user = Map.put(user, :auth_token, token)

              show_user(conn, user)

            {:error, %Ecto.Changeset{} = changeset} ->
              conn
              |> put_status(:unprocessable_entity)
              |> put_view(FinderWeb.ChangesetView)
              |> render("error.json", changeset: changeset)
          end
        end
    end
  end

  def find_user(user_params, email) do
    user_id = user_params["user_id"]

    case user_params["provider"] do
      "apple" ->
        if(email) do
          case Accounts.get_user_with_email(email) do
            nil ->
              Accounts.get_user_with_uid(user_id)

            user ->
              if(is_nil(user.fuild)) do
                {:ok, user} = Accounts.update_user(user, %{fuid: user_id})
                user
              end

              user
          end
        end

      _ ->
        Accounts.get_user_with_email(email)
    end
  end

  def create_user(user_params) do
    Accounts.create_user(user_params)
  end

  def sign_in_and_render(conn, user) do
    with {:ok, token, _claims} <- sign(user) do
      user = Map.put(user, :auth_token, token)
      show_user(conn, user)
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

  def show_user(conn, user) do
    conn
    |> put_view(FinderWeb.UserView)
    |> render("show.json", user: user)
  end
end
