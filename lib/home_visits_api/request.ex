defmodule HomeVisitsApi.Request do
  @moduledoc """
  Request Visit struct
  """

  @type email :: String.t()
  @type date :: Date.t()
  @type minutes :: float()
  @type tasks :: list(String.t())
  @type t :: %__MODULE__{
          email: email,
          date: date,
          minutes: minutes,
          tasks: tasks
        }

  defstruct [:email, :date, :minutes, :tasks]
end
