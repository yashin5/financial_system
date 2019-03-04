defmodule FinancialSystem.SplitList do
  @moduledoc """
  This module make a struct for split transfer.
  """

  @doc """
  Make the struct for split.
  ## Example
      iex> account = FinancialSystem.CreateAccount.create_user("This", "email@email.com", "BRL", 100)
      iex> [%FinancialSystem.SplitList{account: account, percent: 100}]
      [%FinancialSystem.SplitList{account: %FinancialSystem.Account{currency: "BRL", email: "email@email.com", name: "This", value: Decimal.add(100,0) |> Decimal.round(1)}, percent: 100}]
  """
  defstruct [:account, :percent]
end
