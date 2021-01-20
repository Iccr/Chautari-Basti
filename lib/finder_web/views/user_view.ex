defmodule FinderWeb.UserView do
  use FinderWeb, :view
  alias FinderWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      imageurl: user.imageurl,
      name: user.name,
      token: user.auth_token,
      provider: user.provider
    }
  end
end
