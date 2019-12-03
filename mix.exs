defmodule FishingSpot.Mixfile do
  use Mix.Project

  def project do
    [
      app: :fishing_spot,
      version: "0.0.1",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {FishingSpot, []}, extra_applications: [:logger]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:ecto_sql, "~> 3.2"},
      {:ex_doc, "~> 0.21.2", only: :dev},
      {:ex_machina, "~> 2.3", only: :test},
      {:postgrex, "~> 0.15.1"}
    ]
  end

  defp aliases do
    [
      "ecto.rebuild": ["ecto.drop", "ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
