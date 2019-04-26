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
  def to_decimal(value) when is_number(value) do
    case is_integer(value) do
      true -> Decimal.new(value)
      false -> Decimal.from_float(value)
    end
  end

  @doc """
    Verify if currency is valid.

  ## Examples
    currency_is_valid("BRL")
  """
  @spec currency_is_valid(String.t()) :: {:ok, String.t()} | {:error, no_return()}
  def currency_is_valid(currency) when is_binary(currency) do
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
    |> Decimal.mult(
      Decimal.from_float(currency_rate()["quotes"]["USD#{String.upcase(currency_to)}"])
    )
    |> to_integer_do(currency_rate()["decimal"]["USD#{String.upcase(currency_to)}"])
  end

  @doc """
    converts the values ​based on the currency.

  ## Examples
    convert("EUR", "BRL", 10)
  """
  @spec convert(String.t(), String.t(), number()) :: number()
  def convert(currency_from, currency_to, value)
      when is_binary(currency_from) and is_binary(currency_to) and is_number(value) do
    value
    |> to_decimal()
    |> Decimal.div(to_decimal(currency_rate()["quotes"]["USD#{String.upcase(currency_from)}"]))
    |> Decimal.mult(to_decimal(currency_rate()["quotes"]["USD#{String.upcase(currency_to)}"]))
    |> to_integer_do(currency_rate()["decimal"]["USD#{String.upcase(currency_to)}"])
  end

  def to_integer_do(:store, value, currency) do
    to_integer(value, currency_rate()["decimal"]["USD#{String.upcase(currency)}"], :store)
  end

  def to_integer_do(:show, value, currency) do
    to_integer(value, currency_rate()["decimal"]["USD#{String.upcase(currency)}"], :show)
  end

  def to_integer_do(value, currency) do
    to_integer(value, currency, :convert)
  end

  defp to_integer(value, precision, :store) when precision in 0..8 do
    value
    |> to_decimal()
    |> to_integer(precision, :convert)
  end

  defp to_integer(value, precision, :show) when precision in 0..8 do
    value
    |> to_decimal()
    |> Decimal.div(Kernel.trunc(:math.pow(10, precision)))
    |> Decimal.round(precision, :floor)
  end

  defp to_integer(value, 0, :show), do: value

  defp to_integer(value, precision, :convert) when precision in 0..8 do
    value
    |> Decimal.mult(Kernel.trunc(:math.pow(10, precision)))
    |> Decimal.round(0, :floor)
    |> Decimal.to_integer()
    |> Kernel.trunc()
  end
end
