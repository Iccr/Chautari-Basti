defmodule Seed do
  def seed_all do
    seed_districts()
    seed_parkins()
    seed_waters()
    seed_amenities()
  end

  def seed_districts do
    for d <- get_district() do
      Finder.Districts.create_district(d)
    end
  end

  def seed_parkins do
    names = ~w(bike car jeep)
    tags = ~w(1 2 3)

    for {n, t} <- Enum.zip(names, tags) do
      val = Finder.Parkings.create_parking(%{name: n, tag: t})
    end
  end

  def seed_waters do
    # names = ["24/7", "average", "just ok"]
    # tags = ~w(1 2 3)

    # for {n, t} <- Enum.zip(names, tags) do
    #   Finder.Waters.create_water(%{name: n, tag: t})
    # end
  end

  def seed_amenities do
    names = [
      {"Kitchen", 1},
      {"Paid Internet", 2},
      {"Free internet", 3},
      {"Roof top access", 4},
      {"sunbathing place", 5},
      {"Hot water", 6},
      {"Pet Friendly", 7}
    ]

    for {n, t} <- names do
      Finder.Amenities.create_amenity(%{name: n, tag: t})
    end
  end

  defp get_district do
    File.read!("priv/repo/district.json")
    |> Jason.decode!()
  end
end

Seed.seed_all()
