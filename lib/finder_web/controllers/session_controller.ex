defmodule FinderWeb.SessionController do
  use FinderWeb, :controller
  alias Finder.Accounts

  def login(conn, %{"user" => user_params}) do
    user = get_user_with_email_token(user_params)

    if user do
      show_user(conn, user)
    else
      with {:ok, user} = Accounts.create_user(user_params) do
        show_user(conn, user)
      end
    end
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
    |> render("user.json", user: user)
  end
end
