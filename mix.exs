defmodule HomeVisitsApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :home_visits_api,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {HomeVisitsApi.Application, []}
    ]
  end

  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"}
    ]
  end

  defp aliases do
    [
      ecto_setup: ["ecto.create", "ecto.migrate --quiet"]
    ]
  end
end
