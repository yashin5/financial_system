defmodule FinancialSystem.Account do
  @moduledoc """
  This module is responsable for detemrinate the struct of accounts.
  """

  @typedoc """
    Abstract account struct type.
  """
  @type t :: %__MODULE__{account_id: integer(), name: String.t(), currency: String.t(), value: String.t()}

  @enforce_keys [:account_id, :name, :currency, :value]

  defstruct [:account_id, :name, :currency, :value]
end
