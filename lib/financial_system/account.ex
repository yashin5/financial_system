defmodule FinancialSystem.Account do
  @moduledoc """
  This module is responsable for detemrinate the struct of accounts.
  """

  @typedoc """
    Abstract account struct type.
  """
  @type t :: %__MODULE__{name: String.t(), currency: String.t(), value: number()}

  @enforce_keys [:name, :currency, :value]

  defstruct [:name, :currency, :value]
end
