defmodule FinancialSystem.Currency do
  @moduledoc """
  This module is responsable for make conversion of the values in financial operations.
  """

  @spec currency_rate() :: map()
  def currency_rate do
    case File.read("currency_rate.json") do
      {:ok, body} -> Poison.decode!(body)
      {:error, reason} -> reason
    end
  end

    @doc """
    Convert a value to decimal and round it based on currency.

  ## Examples
    FinancialSystem.FinHelpers.to_decimal(10.502323, "CLF")
  """
  @spec to_decimal(Decimal.t(), String.t()) :: Decimal.t()
  def to_decimal(value, currency) when is_binary(currency) do
    with {:ok, _} <- currency_is_valid(currency) do
      value |> Decimal.round(currency_rate()["decimal"]["USD#{currency}"])
    end
  end

  def to_decimal(value) when is_number(value) do
      case is_integer(value) do
        true -> (value / 1) |> Decimal.from_float()
        false -> Decimal.from_float(value)
    end
  end

  @doc """
    Verify if currency is valid.

  ## Examples
    currency_is_valid("BRL")
  """
  @spec currency_is_valid(String.t()) :: {:ok, String.t()} | {:error, no_return()}
  def currency_is_valid(currency)  when is_binary(currency) do
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
  def convert("USD", currency_to, value) when is_binary(currency_to) and is_number(value) do
    to_decimal(value)
    |> Decimal.mult(Decimal.from_float(currency_rate()["quotes"]["USD#{String.upcase(currency_to)}"]) )

  end

  @doc """
    converts the values ​based on the currency.

  ## Examples
    convert("EUR", "BRL", 10)
  """
  @spec convert(String.t(), String.t(), number()) :: number()
  def convert(currency_from, currency_to, value)
      when is_binary(currency_from) and is_binary(currency_to) and is_number(value) do
    to_decimal(value)
    |> Decimal.div(to_decimal(currency_rate()["quotes"]["USD#{String.upcase(currency_from)}"]))
    |> Decimal.mult(to_decimal(currency_rate()["quotes"]["USD#{String.upcase(currency_to)}"]))
  end
end

