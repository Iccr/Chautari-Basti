defmodule Finder.SessionController do
  use FinderWeb, :controller

  def login(conn, %{"user" => user_params}) do
    find_with_token(user_params)
  end

  # def create_user(conn, user_params) do
  # with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
  #   conn
  #   |> put_status(:created)
  #   |> put_resp_header("location", Routes.user_path(conn, :show, user))
  #   |> render("show.json", user: user)
  # end
  # end

  def find_with_token(%{"token" => token}) do
  end

  def find_with_email(%{"email" => email}) do
  end
end
