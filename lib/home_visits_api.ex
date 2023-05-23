defmodule HomeVisitsApi do
  @moduledoc """
    Public API for the HomeVisits application
  """

  alias HomeVisitsApi.User
  alias HomeVisitsApi.Request
  alias HomeVisitsApi.Fulfill
  alias HomeVisitsApi.Visit
  alias HomeVisitsApi.DefaultImpl.Papa
  alias HomeVisitsApi.DefaultImpl.PapaCare
  alias HomeVisitsApi.DefaultImpl.PapaPal

  @spec create_user(User.t()) ::
          {:ok, User.t()}
          | {:error, :email_already_registered}
          | {:error, :invalid_role_specified}
          | {:error, :failed_to_create_user}
          | {:error, :invalid_submission}
  def create_user(user), do: Papa.create_user(user)

  @spec request_visit(Request.t()) ::
          {:ok, :request_pending}
          | {:error, :not_authorized}
          | {:error, :insufficent_minutes}
          | {:error, :unknown_account}
          | {:error, :failed_to_request_visit}
  def request_visit(request), do: PapaCare.request_visit(request)

  @spec fulfill_visit(Fulfill.t()) ::
          {:ok, :fulfilled} | {:error, :not_authorized} | {:error, :failed_to_fulfill}
  def fulfill_visit(fulfillment), do: PapaPal.fulfill_visit(fulfillment)

  @spec fetch_visits() ::
          {:ok, [Visit.t()]} | {:ok, []} | {:error, :failed_to_fetch_visits}
  def fetch_visits(), do: Papa.fetch_visits()

  # @spec start_the_flow(String.t()) ::
  #         {:ok, :credited} | {:error, :tap_already_enabled}
  # def start_the_flow(email) do
  #   Faucet.start_the_flow(email)
  # end
end
