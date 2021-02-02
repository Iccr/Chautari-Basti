defmodule Finder.Release do
  require Logger
  @app :finder

  def migrate do
    load_app()

    for repo <- repos() do
      Logger.info("migrating")
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  def seed() do
    load_app()
    Logger.info("starting seeding")

    filename = Application.app_dir(:finder, "priv/repo/seeds.exs")

    for repo <- repos() do
      {:ok, _, _} =
        Ecto.Migrator.with_repo(repo, fn _repo ->
          if File.regular?(filename) do
            Logger.info("seeding")
            {:ok, Code.eval_file(filename)}
          else
            Logger.info("seed failed complete")
            {:error, "Seeds file not found."}
          end
        end)
    end

    IO.puts("seed run complete")
  end

  # def seed() do
  #   load_app()
  #   repo = Elixir.Finder.Repo
  #   Logger.info("seeeding}")

  #   case Ecto.Migrator.with_repo(repo, eval_seed(repo)) do
  #     {:ok, {:ok, _fun_return}, _apps} ->
  #       :ok

  #     {:ok, {:error, reason}, _apps} ->
  #       Logger.error(reason)
  #       {:error, reason}

  #     {:error, term} ->
  #       IO.warn(term, [])
  #       {:error, term}
  #   end
  # end

  # defp eval_seed(repo) do
  #   seeds_file = get_path(repo, "", "seeds.exs")
  #   Logger.info("seed directory path is}")
  #   Logger.debug("#{IO.inspect(seeds_file)}")

  #   if File.regular?(seeds_file) do
  #     {:ok, Code.eval_file(seeds_file)}
  #   else
  #     {:error, "Seeds file not found."}
  #   end
  # end

  # defp get_path(repo, directory, filename) do
  #   priv_dir = "#{:code.priv_dir(@app)}"

  #   repo_underscore =
  #     repo
  #     |> Module.split()
  #     |> List.last()
  #     |> Macro.underscore()

  #   Path.join([priv_dir, repo_underscore, directory, filename])

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
