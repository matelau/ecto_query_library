use Mix.Config

config :fishing_spot, FishingSpot.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  database: "fishing_spot_test",
  username: "postgres",
  password: "postgres"
