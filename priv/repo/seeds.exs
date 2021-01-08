defmodule Seed do
  def seed_districts do
    for d <- get_district() do
      Finder.Districts.create_district(d)
    end
  end

  defp get_district do
    File.read!("priv/repo/district.json")
    |> Jason.decode!()
  end
end

Seed.seed_districts()
