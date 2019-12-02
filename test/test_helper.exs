Logger.configure(level: :info)
{:ok, _} = Application.ensure_all_started(:ex_machina)
ExUnit.start()

Mix.Task.run("ecto.create", ~w(-r FishingSpot.Repo --quiet))
Mix.Task.run("ecto.migrate", ~w(-r FishingSpot.Repo --quiet))

Ecto.Adapters.SQL.Sandbox.mode(FishingSpot.Repo, :manual)
