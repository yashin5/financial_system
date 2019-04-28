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
    Convert a value to decimal and round it based on currency.

  ## Examples
    FinancialSystem.Currency.to_decimal(10.502323)
  """
  @spec to_decimal(number) :: Decimal.t()
  def to_decimal(value) when is_number(value) do
    case is_integer(value) do
      true -> Decimal.new(value)
      false -> Decimal.from_float(value)
    end
  end

  def to_decimal(_),
    do:
      raise(ArgumentError,
        message: "Arg must be a integer or float."
      )

  defp to_decimal(value, precision, :show) when precision in 0..8 do
    value
    |> to_decimal()
    |> Decimal.div(Kernel.trunc(:math.pow(10, precision)))
    |> Decimal.round(precision, :floor)
  end

  @doc """
    Verify if currency is valid.

  ## Examples
    FinancialSystem.Currency.currency_is_valid("BRL")
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
    FinancialSystem.Currency.convert("USD", "BRL", 10)
  """
  @spec convert(String.t(), pid(), number()) :: number()
  def convert("USD", currency_to, value)
      when is_binary(currency_to) and value > 0 and is_number(value) do
    with {:ok, currency_to_upcase} <- currency_is_valid(currency_to) do
      to_decimal(value)
      |> Decimal.mult(Decimal.from_float(currency_rate()["quotes"]["USD#{currency_to_upcase}"]))
      |> amount_do(currency_rate()["decimal"]["USD#{currency_to_upcase}"])
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
      when is_binary(currency_from) and value > 0 and is_binary(currency_to) and is_number(value) do
    with {:ok, currency_from_upcase} <- currency_is_valid(currency_from),
         {:ok, currency_to_upcase} <- currency_is_valid(currency_to) do
      value
      |> to_decimal()
      |> Decimal.div(to_decimal(currency_rate()["quotes"]["USD#{currency_from_upcase}"]))
      |> Decimal.mult(to_decimal(currency_rate()["quotes"]["USD#{currency_to_upcase}"]))
      |> amount_do(currency_rate()["decimal"]["USD#{currency_to_upcase}"])
    end
  end

  def convert(_, _, _),
    do:
      raise(ArgumentError,
        message: "Check the parameters what are passed to the function."
      )

  @doc """
    converts the value to integer ​based on the currency to storage.

  ## Examples
    FinancialSystem.Currency.amount_do(:store, 10, "BRL")
  """
  @spec amount_do(atom(), number(), String.t()) :: integer() | no_return()
  def amount_do(:store = operation, value, currency)
      when is_atom(operation) and is_number(value) and value >= 0 and is_binary(currency) do
    with {:ok, currency_upcase} <- currency_is_valid(currency) do
      to_integer(value, currency_rate()["decimal"]["USD#{currency_upcase}"], :store)
    end
  end

  @doc """
    converts the value to decimal based in currency to show to the user.

  ## Examples
    FinancialSystem.Currency.amount_do(:store, 10, "BRL")
  """
  def amount_do(:show = operation, value, currency)
      when is_atom(operation) and is_number(value) and value >= 0 and is_binary(currency) do
    with {:ok, currency_upcase} <- currency_is_valid(currency) do
      to_decimal(value, currency_rate()["decimal"]["USD#{currency_upcase}"], :show)
    end
  end

  def amount_do(_, _, _),
    do:
      raise(ArgumentError,
        message:
          "The first arg must be :store or :show, second arg must be a number and third must be a valid currency"
      )

  defp amount_do(value, precision) do
    to_integer(value, precision, :convert)
  end

  defp to_integer(value, precision, :store) when precision in 0..8 do
    value
    |> to_decimal()
    |> to_integer(precision, :convert)
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
