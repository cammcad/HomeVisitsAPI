defmodule HomeVisitsApi.DefaultImpl.PapaCare do
  @moduledoc false

  alias HomeVisitsApi.Request
  alias HomeVisitsApi.DefaultImpl.DataStore

  @spec request_visit(Request.t()) ::
          {:ok, :request_pending} | {:error, :not_authorized} | {:error, :insufficent_minutes}
  def request_visit(request) do
    request
    |> Map.from_struct()
    |> DataStore.request_visit()
  end
end
