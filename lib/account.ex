defmodule FinancialSystem.Account do
  @moduledoc """
  This module make a struct for the user account.
  """

  @doc """
  Create a struct to user account
  ## Example
      iex> %FinancialSystem.Account{name: "This", email: "is@email.com", currency: "BRL", value: 200}
      %FinancialSystem.Account{currency: "BRL", email: "is@email.com", name: "This", value: 200}
  """
  defstruct [:name, :email, :currency, :value]
end
