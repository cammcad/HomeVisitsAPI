defmodule HomeVisitsApi.User do
  @moduledoc """
  User struct
  """

  @type first_name :: String.t()
  @type last_name :: String.t()
  @type email :: String.t()
  @type roles :: String.t()
  @type t :: %__MODULE__{
          first_name: first_name,
          last_name: last_name,
          email: email,
          roles: roles
        }

  defstruct [:first_name, :last_name, :email, :roles]
end
