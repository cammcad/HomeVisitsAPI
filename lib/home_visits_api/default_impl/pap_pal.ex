defmodule HomeVisitsApi.DefaultImpl.PapaPal do
  @moduledoc false

  alias HomeVisitsApi.Fulfill
  alias HomeVisitsApi.DefaultImpl.DataStore

  @spec fulfill_visit(Fulfill.t()) ::
          {:ok, :fulfilled} | {:error, :not_authorized} | {:error, :failed_to_fulfill}
  def fulfill_visit(fulfillment), do: DataStore.fulfill_visit(fulfillment)
end
