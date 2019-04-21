defmodule FinancialSystem.Currency do
  @moduledoc """
  This module is responsable for make conversion of the values in financial operations.
  """

  @spec currency_rate() :: map()
  defp currency_rate do
    case File.read("currency_rate.json") do
      {:ok, body} -> Poison.decode!(body)
      {:error, reason} -> reason
    end
  end

  @doc """
    Verify if currency is valid.

  ## Examples
    currency_is_valid?("BRL")
  """
  @spec currency_is_valid?(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def currency_is_valid?(currency) do
    is_valid? = Map.has_key?(currency_rate()["quotes"], "USD#{String.upcase(currency)}")

    case is_valid? do
      true ->
        {:ok, String.upcase(currency)}

      false ->
        {:error,
         raise(ArgumentError,
           message: "The currency is not valid. Please, check it and try again."
         )}
    end
  end

  @doc """
    converts the values from USD ​​based on the currency.

  ## Examples
    convert("USD", "BRL", 10)
  """
  @spec convert(String.t(), pid(), number()) :: number()
  def convert("USD", currency_to, value) do
    value * currency_rate()["quotes"]["USD#{String.upcase(currency_to)}"]
  end

  @doc """
    converts the values ​based on the currency.

  ## Examples
    convert("EUR", "BRL", 10)
  """
  @spec convert(String.t(), String.t(), number()) :: number()
  def convert(currency_from, currency_to, value) do
    value / currency_rate()["quotes"]["USD#{String.upcase(currency_from)}"] *
      currency_rate()["quotes"]["USD#{String.upcase(currency_to)}"]
  end
end
