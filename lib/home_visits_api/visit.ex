defmodule HomeVisitsApi.Visit do
  @moduledoc """
  Visit struct
  """

  @type id :: String.t()
  @type tasks :: String.t()
  @type minutes :: String.t()
  @type date :: String.t()
  @type t :: %__MODULE__{
          id: id,
          tasks: tasks,
          minutes: minutes,
          date: date
        }

  defstruct [:id, :tasks, :minutes, :date]
end
