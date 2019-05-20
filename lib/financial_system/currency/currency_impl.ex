defmodule FinancialSystem.Currency.CurrencyImpl do
  @moduledoc """
  This module is responsable to simulate  requests to an API.
  """
  @behaviour FinancialSystem.Currency.CurrencyBehaviour

  alias FinancialSystem.Currency.CurrencyBehaviour

  # TODO: Move code from CurrencyRequest.load_from_config/0 to this module

  defp get_currency, do: Application.get_env(:financial_system, :currency_request)

  @doc """
    Verify if currency is valid.

  ## Examples
    FinancialSystem.Currency.CurrencyImpl.currency_is_valid("BRL")
  """
  @impl CurrencyBehaviour
  def currency_is_valid(currency) when byte_size(currency) > 0 and is_binary(currency) do
    get_currency().load_from_config()["quotes"]
    |> Map.has_key?("USD#{String.upcase(currency)}")
    |> do_currency_is_valid(currency)
  end

  defp do_currency_is_valid(true, currency), do: {:ok, String.upcase(currency)}

  defp do_currency_is_valid(false, _) do
    {:error, "The currency is not valid. Please, check it and try again."}
  end

  @doc """
    Get the decimal precision of a currency.

  ## Examples
    FinancialSystem.Currency.CurrencyImpl.get_from_currency(:precision, "BRL")
  """
  @impl CurrencyBehaviour
  def get_from_currency(:precision = operation, currency)
      when is_atom(operation) and is_binary(currency) and byte_size(currency) > 0 do
    with {:ok, _} <- currency_is_valid(currency) do
      {:ok, get_currency().load_from_config()["decimal"]["USD#{currency}"]}
    end
  end

  @doc """
    Get the current value of currency.

  ## Examples
    FinancialSystem.Currency.CurrencyImpl.get_from_currency(:value, "BRL")
  """
  def get_from_currency(:value = operation, currency)
      when is_atom(operation) and is_binary(currency) and byte_size(currency) > 0 do
    with {:ok, _} <- currency_is_valid(currency) do
      {:ok, get_currency().load_from_config()["quotes"]["USD#{currency}"]}
    end
  end
end
