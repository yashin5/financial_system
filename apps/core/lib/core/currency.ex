defmodule FinancialSystem.Core.Currency do
  @moduledoc """
  This module is responsable for make conversion of the values in financial operations.
  """

  alias FinancialSystem.Core.Currency.CurrencyImpl

  @doc """
  Convert a number in type string to decimal.

  ## Examples
      FinancialSystem.Core.Currency.to_decimal("10.502323")
  """
  @spec to_decimal(String.t() | number(), none() | integer(), none() | atom()) ::
          {:ok, Decimal.t()} | Decimal.t() | String.t() | no_return()
  def to_decimal(value) when is_binary(value) do
    {:ok, Decimal.new(value)}
  rescue
    Decimal.Error -> {:error, :invalid_value_type}
  end

  @doc """
  Convert a number in integer type to decimal.

  ## Examples
      FinancialSystem.Core.Currency.to_decimal(10)
  """
  def to_decimal(value) when is_integer(value) do
    {:ok, Decimal.new(value)}
  end

  @doc """
  Convert a number in float type to decimal.

  ## Examples
      FinancialSystem.Core.Currency.to_decimal(10.502323)
  """
  def to_decimal(value) when is_float(value) do
    {:ok, Decimal.from_float(value)}
  end

  def to_decimal(_),
    do: {:error, :invalid_value_type}

  defp to_decimal(value, precision, :show) when precision in 0..8 do
    with {:ok, value_in_decimal} <- to_decimal(value) do
      value_in_decimal
      |> Decimal.div(Kernel.trunc(:math.pow(10, precision)))
      |> Decimal.round(precision, :floor)
      |> Decimal.to_string()
    end
  end

  defp is_greater_or_equal_than_0(decimal) do
    decimal
    |> Decimal.cmp(Decimal.new(0))
    |> do_is_greater_or_equal_than_0(decimal)
  end

  defp do_is_greater_or_equal_than_0(response, decimal) when response in [:gt, :eq] do
    {:ok, decimal}
  end

  defp do_is_greater_or_equal_than_0(:lt, _),
    do: {:error, :invalid_value_less_than_0}


  @doc """
  converts the values ​based on the currency and transform them in
  integers.

  ## Examples
      FinancialSystem.Core.Currency.convert("USD", "BRL", "10")
      FinancialSystem.Core.Currency.convert("EUR", "BRL", "10")
  """
  @spec convert(String.t(), String.t(), String.t()) :: {:ok, integer()} | {:error, atom()}
  def convert(currency_from, currency_to, value) when is_binary(currency_from) and is_binary(currency_to) and is_binary(value) and currency_from == currency_to do
    with {:ok, currency_to_upcase} <- CurrencyImpl.currency_is_valid(currency_to),
      {:ok, decimal_not_evaluated} <- to_decimal(value),
      {:ok, currency_to_decimal_precision} <-
        CurrencyImpl.get_from_currency(:precision, currency_to_upcase),
      {:ok, decimal_evaluated} <- is_greater_or_equal_than_0(decimal_not_evaluated) do
    decimal_evaluated
    |> amount_do(currency_to_decimal_precision)
    end
  end

  def convert("USD", currency_to, value)
      when is_binary(currency_to) and is_binary(value) do
    with {:ok, currency_to_upcase} <- CurrencyImpl.currency_is_valid(currency_to),
         {:ok, decimal_not_evaluated} <- to_decimal(value),
         {:ok, currency_to_value} <-
           CurrencyImpl.get_from_currency(:value, currency_to_upcase),
         {:ok, currency_to_decimal_precision} <-
           CurrencyImpl.get_from_currency(:precision, currency_to_upcase),
         {:ok, currency_to_decimal} <-
           to_decimal(currency_to_value),
         {:ok, decimal_evaluated} <- is_greater_or_equal_than_0(decimal_not_evaluated) do
      decimal_evaluated
      |> Decimal.mult(currency_to_decimal)
      |> amount_do(currency_to_decimal_precision)
    end
  end

  def convert(currency_from, currency_to, value)
      when is_binary(currency_from) and value > 0 and is_binary(currency_to) and is_binary(value) do
    with {:ok, currency_from_upcase} <- CurrencyImpl.currency_is_valid(currency_from),
         {:ok, currency_to_upcase} <- CurrencyImpl.currency_is_valid(currency_to),
         {:ok, decimal_not_evaluated} <- to_decimal(value),
         {:ok, currency_from_value} <-
           CurrencyImpl.get_from_currency(:value, currency_from_upcase),
         {:ok, currency_to_value} <-
           CurrencyImpl.get_from_currency(:value, currency_to_upcase),
         {:ok, currency_to_decimal_precision} <-
           CurrencyImpl.get_from_currency(:precision, currency_to_upcase),
         {:ok, currency_from_decimal} <-
           to_decimal(currency_from_value),
         {:ok, currency_to_decimal} <-
           to_decimal(currency_to_value),
         {:ok, decimal_evaluated} <- is_greater_or_equal_than_0(decimal_not_evaluated) do
      decimal_evaluated
      |> Decimal.div(currency_from_decimal)
      |> Decimal.mult(currency_to_decimal)
      |> amount_do(currency_to_decimal_precision)
    end
  end

  def convert(currency_from, currency_to, value)
      when not is_binary(currency_from) and is_binary(currency_to) and
             value > 0 and is_binary(value) do
    {:error, :invalid_currency_type}
  end

  def convert(currency_from, currency_to, value)
      when is_binary(currency_from) and not is_binary(currency_to) and value > 0 and
             is_binary(value) do
    {:error, :invalid_currency_type}
  end

  def convert(currency_from, currency_to, value)
      when is_binary(currency_from) and is_binary(currency_to) and
             value > 0 and not is_binary(value) do
    {:error, :invalid_value_type}
  end

  def convert(currency_from, currency_to, value)
      when is_binary(currency_from) and is_binary(currency_to) and
             not value > 0 and is_binary(value) do
    {:error, :invalid_value_less_or_equal_than_0}
  end

  def convert(_, _, _), do: {:error, :invalid_arguments_type}

  @doc """
  converts the value to string based in currency to show to the user.

  ## Examples
      FinancialSystem.Core.Currency.amount_do(:show, 10, "BRL")
  """
  @spec amount_do(atom(), pos_integer() | String.t(), String.t()) ::
          {:ok, String.t() | pos_integer()} | {:error, atom()}
  def amount_do(:show = operation, value, currency)
      when is_atom(operation) and is_integer(value) and value >= 0 and is_binary(currency) do
    with {:ok, currency_upcase} <- CurrencyImpl.currency_is_valid(currency),
         {:ok, currency_precision} <- CurrencyImpl.get_from_currency(:precision, currency_upcase) do
      {:ok, to_decimal(value, currency_precision, :show)}
    end
  end

  @doc """
  converts the value to integer to store in the state.

  ## Examples
      FinancialSystem.Core.Currency.amount_do(:store, "10", "BRL")
  """
  def amount_do(:store = operation, value, currency)
      when is_atom(operation) and is_binary(value) and is_binary(currency) do
    with {:ok, currency_upcase} <- CurrencyImpl.currency_is_valid(currency),
         {:ok, decimal_not_evaluated} <- to_decimal(value),
         {:ok, decimal_evaluated} <- is_greater_or_equal_than_0(decimal_not_evaluated),
         {:ok, currency_precision} <- CurrencyImpl.get_from_currency(:precision, currency_upcase),
         {:ok, value_in_integer} <- make_integer(decimal_evaluated, currency_precision, :store) do
      {:ok, value_in_integer }
    end
  end

  def amount_do(operation, value, currency)
      when not is_atom(operation) and is_binary(value) and is_binary(currency) do
    {:error, :invalid_operation_type}
  end

  def amount_do(operation, value, currency)
      when is_atom(operation) and not is_binary(value) and is_binary(currency) do
    {:error, :invalid_value_type}
  end

  def amount_do(operation, value, currency)
      when is_atom(operation) and is_binary(value) and not is_binary(currency) do
    {:error, :invalid_currency_type}
  end

  def amount_do(_, _, _), do: {:error, :invalid_arguments_type}

  defp amount_do(value, precision) do
    with {:ok, value_in_integer} <- make_integer(value, precision, :do_operation)  do
      {:ok, value_in_integer}
    end
  end

  defp make_integer(value, precision, :store) when precision in 0..8 do
    {:ok, to_integer(value, precision, :convert)}
  end

  defp make_integer(value, precision, :do_operation) when precision in 0..8 do
    value |> to_integer(precision, :convert) |> do_to_integer
  end

  defp to_integer(value, precision, :convert) when precision in 0..8 do
    value
    |> Decimal.mult(Kernel.trunc(:math.pow(10, precision)))
    |> Decimal.round(0, :floor)
    |> Decimal.to_integer()
    |> Kernel.trunc()
  end

  defp do_to_integer(value)when value > 0, do: {:ok, value}

  defp do_to_integer(value) when value <= 0, do: {:error, :value_is_too_low_to_convert_to_the_currency}
end
