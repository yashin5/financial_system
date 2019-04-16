defmodule FinancialSystem.AccountDefinition do
  @moduledoc """
  This module is responsable for detemrinate the struct of accounts.
  """

  defstruct [:name, :email, :currency, :value]
end
