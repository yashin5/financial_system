defmodule FinancialSystem.Core.Currency.CurrencyBehaviour do
  @moduledoc false

  @callback currency_is_valid(String.t()) :: {:ok, String.t()} | {:error, atom()}
  @callback get_from_currency(atom(), String.t()) :: {:ok, number()} | {:error, atom()}
end
