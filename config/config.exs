import Config

config :home_visits_api,
  ecto_repos: [HomeVisitsApi.Repo, HomeVisitsApiTest.Repo]

config :home_visits_api, HomeVisitsApiTest.Repo,
  username: "postgres",
  password: "postgres",
  database: "homevisitsdb_test",
  hostname: "localhost",
  port: 5432,
  pool: Ecto.Adapters.SQL.Sandbox

config :home_visits_api, HomeVisitsApi.Repo,
  database: "homevisitsdb",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432"
