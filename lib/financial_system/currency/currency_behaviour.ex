defmodule FinancialSystem.Currency.CurrencyBehaviour do
  @callback currency_is_valid(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  @callback get_from_currency(atom(), String.t()) :: {:ok, number()} | {:error, String.t()}
end
