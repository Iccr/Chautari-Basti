defmodule FinderWeb.ParkingView do
  use FinderWeb, :view
  alias FinderWeb.ParkingView

  def render("index.json", %{parkings: parkings}) do
    %{data: render_many(parkings, ParkingView, "parking.json")}
  end

  def render("show.json", %{parking: parking}) do
    %{data: render_one(parking, ParkingView, "parking.json")}
  end

  def render("parking.json", %{parking: parking}) do
    %{id: parking.id,
      name: parking.name,
      tag: parking.tag}
  end
end
