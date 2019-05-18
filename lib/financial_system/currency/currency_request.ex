defmodule FinancialSystem.Currency.CurrencyRequest do
  @moduledoc """
  This module is responsable to simulate a API what retuns the currency
  and decimal precision of currencys.
  """
  @callback load_from_config() :: map() | no_return()

  def load_from_config do
    get_currency_path()
    |> File.read()
    |> do_load_from_config()
  end

  defp do_load_from_config({:ok, body}), do: Poison.decode!(body)

  defp do_load_from_config({:error, reason}), do: reason

  defp get_currency_path do
    Application.get_env(:financial_system, :file)
  end
end
