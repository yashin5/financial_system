defmodule FinancialSystem.Currency.CurrencyRequest do
  @moduledoc """
  This module is responsable to simulate  requests to get the data from currencies.
  """

  defp load_from_config do
    case File.read(get_currency_path()) do
      {:ok, body} -> Poison.decode!(body)
      {:error, reason} -> reason
    end
  end

  @doc """
    Verify if currency is valid.

  ## Examples
    FinancialSystem.Currency.CurrencyRequest.currency_is_valid("BRL")
  """
  @spec currency_is_valid(String.t()) :: {:ok, String.t()} | {:error, no_return()}
  def currency_is_valid(currency) when byte_size(currency) > 0 and is_binary(currency) do
    is_valid? = Map.has_key?(load_from_config()["quotes"], "USD#{String.upcase(currency)}")

    do_currency_is_valid(is_valid?, currency)
  end

  defp do_currency_is_valid(true, currency), do: {:ok, String.upcase(currency)}

  defp do_currency_is_valid(false, _) do
    {:error,
     raise(ArgumentError,
       message: "The currency is not valid. Please, check it and try again."
     )}
  end

  @doc """
    Get the decimal precision of a currency.

  ## Examples
    FinancialSystem.Currency.CurrencyRequest.get_from_currency(:precision, "BRL")
  """
  @spec get_from_currency(atom(), String.t()) :: integer() | number() | no_return()
  def get_from_currency(:precision = operation, currency)
      when is_atom(operation) and is_binary(currency) and byte_size(currency) > 0 do
    with {:ok, _} <- currency_is_valid(currency) do
      load_from_config()["decimal"]["USD#{currency}"]
    end
  end

  @doc """
    Get the current value of currency.

  ## Examples
    FinancialSystem.Currency.CurrencyRequest.get_from_currency(:value, "BRL")
  """
  def get_from_currency(:value = operation, currency)
      when is_atom(operation) and is_binary(currency) and byte_size(currency) > 0 do
    with {:ok, _} <- currency_is_valid(currency) do
      load_from_config()["quotes"]["USD#{currency}"]
    end
  end

  defp get_currency_path do
    Application.get_env(:financial_system, :file)
  end
end
