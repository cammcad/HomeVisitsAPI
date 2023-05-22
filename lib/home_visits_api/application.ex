defmodule HomeVisitsApi.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      HomeVisitsApi.Repo
    ]

    opts = [strategy: :one_for_one, name: HomeVisitsApi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
