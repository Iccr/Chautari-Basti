defmodule FinderWeb.WaterView do
  use FinderWeb, :view
  alias FinderWeb.WaterView

  def render("index.json", %{waters: waters}) do
    %{data: render_many(waters, WaterView, "water.json")}
  end

  def render("show.json", %{water: water}) do
    %{data: render_one(water, WaterView, "water.json")}
  end

  def render("water.json", %{water: water}) do
    %{id: water.id,
      name: water.name,
      tag: water.tag}
  end
end
