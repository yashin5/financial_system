defmodule FinancialSystem.Currency do
  @moduledoc """
  This module is responsable for make conversion of the values in financial operations.
  """

  alias FinancialSystem.Currency.CurrencyRequest

  @doc """
    Convert a value to decimal and round it based on currency.

  ## Examples
    FinancialSystem.Currency.to_decimal(10.502323)
  """
  @spec to_decimal(String.t() | number(), none() | integer(), atom()) :: {:ok, Decimal.t()} | Decimal.t()  |  String.t() | no_return()
  def to_decimal(value) when is_binary(value) do
    try do
      {:ok, Decimal.new(value)}
    rescue
      Decimal.Error -> {:error, raise(ArgumentError, message: "The value must be a string.")}
    end
  end

  def to_decimal(value) when is_number(value) do
    case is_integer(value) do
      true -> Decimal.new(value)
      false -> Decimal.from_float(value)
    end
  end

  def to_decimal(_), do: raise(ArgumentError, message: "The arg must be a integer, float or number string.")

  defp to_decimal(value, precision, :show) when precision in 0..8 do
    value
    |> to_decimal()
    |> Decimal.div(Kernel.trunc(:math.pow(10, precision)))
    |> Decimal.round(precision, :floor)
    |> Decimal.to_string()
  end

  defp is_greater_or_equal_than_0(decimal) do
    case Decimal.cmp(decimal, Decimal.new(0)) do
      :gt -> {:ok, decimal}
      :eq -> {:ok, decimal}
      :lt -> {:error, raise(ArgumentError, message: "The value must be greater or equal to 0.")}
    end
  end

  @doc """
    converts the values from USD ​​based on the currency.

  ## Examples
    FinancialSystem.Currency.convert("USD", "BRL", 10)
  """
  @spec convert(String.t(), pid(), number()) :: number()
  def convert("USD", currency_to, value)
      when is_binary(currency_to) and value > 0 and is_number(value) do
    with {:ok, currency_to_upcase} <- CurrencyRequest.currency_is_valid(currency_to),
         {:ok, decimal_not_evaluated} <- to_decimal(value),
         {:ok, decimal_evaluated} <- is_greater_or_equal_than_0(decimal_not_evaluated) do

      decimal_evaluated
      |> Decimal.mult(
        Decimal.from_float(CurrencyRequest.get_from_currency(:value, currency_to_upcase))
      )
      |> amount_do(CurrencyRequest.get_from_currency(:precision, currency_to_upcase))
    end
  end

  @doc """
    converts the values ​based on the currency and transform them in
    integers.

  ## Examples
    FinancialSystem.Currency.convert("EUR", "BRL", 10)
  """
  @spec convert(String.t(), String.t(), number()) :: integer()
  def convert(currency_from, currency_to, value)
      when is_binary(currency_from) and value > 0 and is_binary(currency_to) and is_binary(value) do
    with {:ok, currency_from_upcase} <- CurrencyRequest.currency_is_valid(currency_from),
         {:ok, currency_to_upcase} <- CurrencyRequest.currency_is_valid(currency_to),
         {:ok, decimal_not_evaluated} <- to_decimal(value),
         {:ok, decimal_evaluated} <- is_greater_or_equal_than_0(decimal_not_evaluated) do
      decimal_evaluated
      |> Decimal.div(to_decimal(CurrencyRequest.get_from_currency(:value, currency_from_upcase)))
      |> Decimal.mult(to_decimal(CurrencyRequest.get_from_currency(:value, currency_to_upcase)))
      |> amount_do(CurrencyRequest.get_from_currency(:precision, currency_to_upcase))
    end
  end

  def convert(_, _, _),
    do:
      raise(ArgumentError,
        message: "Check the parameters what are passed to the function."
      )

  @doc """
    converts the value to decimal based in currency to show to the user.

  ## Examples
    FinancialSystem.Currency.amount_do(:store, 10, "BRL")
  """
  def amount_do(:show = operation, value, currency)
      when is_atom(operation) and is_number(value) and value >= 0 and is_binary(currency) do
    with {:ok, currency_upcase} <- CurrencyRequest.currency_is_valid(currency) do
      to_decimal(value, CurrencyRequest.get_from_currency(:precision, currency_upcase), :show)
    end
  end

  def amount_do(:store = operation, value, currency)
      when is_atom(operation) and is_binary(value) and is_binary(currency) do
    with {:ok, currency_upcase} <- CurrencyRequest.currency_is_valid(currency),
         {:ok, decimal_not_evaluated} <- to_decimal(value),
         {:ok, decimal_evaluated} <- is_greater_or_equal_than_0(decimal_not_evaluated) do
      {:ok,
       to_integer(
         decimal_evaluated,
         CurrencyRequest.get_from_currency(:precision, currency_upcase),
         :convert
       )}
    end
  end

  def amount_do(_, _, _),
    do:
      raise(ArgumentError,
        message:
          "The first arg must be :store or :show, second arg must be a number and third must be a valid currency"
      )

  defp amount_do(value, precision) do
    {:ok, to_integer(value, precision, :convert)}
  end

  defp to_integer(value, precision, :convert) when precision in 0..8 do
    value
    |> Decimal.mult(Kernel.trunc(:math.pow(10, precision)))
    |> Decimal.round(0, :floor)
    |> Decimal.to_integer()
    |> Kernel.trunc()
  end
end
