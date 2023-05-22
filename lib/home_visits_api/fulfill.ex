defmodule HomeVisitsApi.Fulfill do
  @moduledoc """
  Fulfill Visit struct
  """

  @type id :: String.t()
  @type email :: String.t()
  @type t :: %__MODULE__{
          id: id,
          email: email
        }

  defstruct [:id, :email]
end
