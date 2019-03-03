defmodule FinancialSystem.CreateAccount do

    alias FinancialSystem.Account, as: Account
    alias FinancialSystem.CurrencyConvert, as: CurrencyConvert
    alias FinancialSystem.FinHelpers, as: FinHelpers

  def create_user(name, email, currency, initial_value) when is_number(initial_value) do
    currency
    |> CurrencyConvert.currency_is_valid?(%Account{name: name, email: email, currency: currency, value: FinHelpers.to_decimal(initial_value)})
  end
end