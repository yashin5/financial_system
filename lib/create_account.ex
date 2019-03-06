defmodule FinancialSystem.CreateAccount do
  @moduledoc """
  This module is responsable for create user accounts.
  """

  alias FinancialSystem.Account, as: Account
  alias FinancialSystem.CurrencyConvert, as: CurrencyConvert
  alias FinancialSystem.FinHelpers, as: FinHelpers

  @doc """
  Create user account
  ## Example
      iex> FinancialSystem.CreateAccount.create_user("This", "is@email.com", "BRL", 200)
      %FinancialSystem.Account{currency: "BRL", email: "is@email.com", name: "This", value: Decimal.add(200,0) |> Decimal.round(1)}
  """
  @spec create_user(any(), any(), binary(), number()) :: any()
  def create_user(name, email, currency, initial_value) when is_number(initial_value) do
    currency
    |> CurrencyConvert.currency_is_valid?(%Account{
      name: name,
      email: email,
      currency: currency,
      value: FinHelpers.to_decimal(initial_value)
    })
  end
end
