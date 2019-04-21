defmodule FinancialSystem.AccountDefinition do
  @moduledoc """
  This module is responsable for detemrinate the struct of accounts.
  """
  @enforce_keys [:name, :currency, :value]

  defstruct [:name, :currency, :value]
end
