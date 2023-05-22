import Config

config :home_visits_api,
  ecto_repos: [HomeVisitsApi.Repo]

config :home_visits_api, HomeVisitsApi.Repo,
  database: "homevisitsdb",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432"
