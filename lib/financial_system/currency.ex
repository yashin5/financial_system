defmodule FinancialSystem.Currency do
  @moduledoc """
  This module is responsable for make conversion of the values in financial operations.
  """

  alias FinancialSystem.Currency.CurrencyRequest

  @doc """
    Convert a number in type string to decimal.

  ## Examples
    FinancialSystem.Currency.to_decimal("10.502323")
  """
  @spec to_decimal(String.t() | number(), none() | integer(), none() | atom()) ::
          {:ok, Decimal.t()} | Decimal.t() | String.t() | no_return()
  def to_decimal(value) when is_binary(value) do
    try do
      {:ok, Decimal.new(value)}
    rescue
      Decimal.Error -> {:error, raise(ArgumentError, message: "The value must be a string.")}
    end
  end

  @doc """
    Convert a number in integer or float type to decimal.

  ## Examples
    FinancialSystem.Currency.to_decimal(10.502323)
  """
  def to_decimal(value) when is_integer(value) do
    Decimal.new(value)
  end

  def to_decimal(value) when is_float(value) do
    Decimal.from_float(value)
  end

  def to_decimal(_),
    do: raise(ArgumentError, message: "The arg must be a integer, float or number string.")

  defp to_decimal(value, precision, :show) when precision in 0..8 do
    value
    |> to_decimal()
    |> Decimal.div(Kernel.trunc(:math.pow(10, precision)))
    |> Decimal.round(precision, :floor)
    |> Decimal.to_string()
  end

  defp is_greater_or_equal_than_0(decimal) do
    Decimal.cmp(decimal, Decimal.new(0))
    |> do_is_greater_or_equal_than_0(decimal)
  end

  defp do_is_greater_or_equal_than_0(response, decimal) when response in [:gt, :eq] do
    {:ok, decimal}
  end

  defp do_is_greater_or_equal_than_0(:lt, _),
    do: {:error, raise(ArgumentError, message: "The value must be greater or equal to 0.")}

  @doc """
    converts the values from USD ​​based on the currency.

  ## Examples
    FinancialSystem.Currency.convert("USD", "BRL", "10")
  """
  @spec convert(String.t(), pid(), number()) :: {:ok, integer()} | no_return()
  def convert("USD", currency_to, value)
      when is_binary(currency_to) and is_binary(value) do
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
        message:
          "The first and second args must be a valid currencys and third arg must be a number in string type."
      )

  @doc """
    converts the value to string based in currency to show to the user.

  ## Examples
    FinancialSystem.Currency.amount_do(:show, 10, "BRL")
  """
  @spec amount_do(atom(), integer() | String.t(), String.t()) ::
          String.t() | {:ok, integer()} | no_return()
  def amount_do(:show = operation, value, currency)
      when is_atom(operation) and is_number(value) and value >= 0 and is_binary(currency) do
    with {:ok, currency_upcase} <- CurrencyRequest.currency_is_valid(currency) do
      to_decimal(value, CurrencyRequest.get_from_currency(:precision, currency_upcase), :show)
    end
  end

  @doc """
    converts the value to integer to store in the state.

  ## Examples
    FinancialSystem.Currency.amount_do(:store, "10", "BRL")
  """
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
