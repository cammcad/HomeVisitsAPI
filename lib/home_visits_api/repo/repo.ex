defmodule HomeVisitsApi.Repo do
  use Ecto.Repo,
    otp_app: :home_visits_api,
    adapter: Ecto.Adapters.Postgres
end
