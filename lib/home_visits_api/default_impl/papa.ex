defmodule HomeVisitsApi.DefaultImpl.Papa do
  @moduledoc false

  alias HomeVisitsApi.User
  alias HomeVisitsApi.DefaultImpl.DataStore

  @spec create_user(User.t()) ::
          {:ok, User.t()} | {:error, :email_already_registered} | {:error, :invalid_email}
  def create_user(user) when is_binary(user.email) do
    user
    |> Map.from_struct()
    |> DataStore.create_user()
  end

  @spec fetch_visits() ::
          {:ok, [Visit.t()]} | {:ok, []} | {:error, :failed_to_fetch_visits}
  def fetch_visits(), do: DataStore.fetch_visits()
end
