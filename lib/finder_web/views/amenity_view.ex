defmodule FinderWeb.AmenityView do
  use FinderWeb, :view
  alias FinderWeb.AmenityView

  def render("index.json", %{amenities: amenities}) do
    %{data: render_many(amenities, AmenityView, "amenity.json")}
  end

  def render("show.json", %{amenity: amenity}) do
    %{data: render_one(amenity, AmenityView, "amenity.json")}
  end

  def render("amenity.json", %{amenity: amenity}) do
    %{id: amenity.id, name: amenity.name, tag: amenity.tag}
  end
end
