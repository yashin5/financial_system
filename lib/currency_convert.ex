defmodule FinancialSystem.CurrencyConvert do
  @moduledoc """
  This module make the conversion of values to this application.
  """

  alias FinancialSystem.FinHelpers, as: FinHelpers

  @doc """
  Transform the number integer or float in decimal.
  ## Example
      FinancialSystem.CurrencyConvert.currency_rate()["quotes"]
  """
  @spec currency_rate() :: false | nil | true | binary() | [any()] | number() | {:error} | map()
  def currency_rate do
    # Getting currency list
    case File.read("currency_rate.json") do
      {:ok, body} -> Poison.decode!(body)
      {:error, _reason} -> {:error}
    end
  end

  @doc """
  Convert the value.
  ## Example
      iex> FinancialSystem.CurrencyConvert.convert(Decimal.add(1,0), "USD", "BRL") |> Decimal.to_float()
      3.7
      iex> FinancialSystem.CurrencyConvert.convert(Decimal.add(1,0), "EUR", "BRL") |> Decimal.to_float()
      4.37
  """
  @spec convert(binary() | integer() | Decimal.t(), binary(), binary()) :: Decimal.t()
  def convert(value, code, account_code) do
    code = String.upcase(code)
    account_code = String.upcase(account_code)

    if currency_is_valid?(code, true) and
         currency_is_valid?(account_code, true) and value > Decimal.add(0, 0) do
      if code == "USD" do
        convert_from_USD(account_code, value)
      else
        convert_from_others(code, value, account_code)
      end
    else
      raise(ArgumentError, message: "invalid value")
    end
  end

  @doc """
  Convert value from USD.
  ## Example
      iex> FinancialSystem.CurrencyConvert.convert_from_USD("BRL", 1) |> Decimal.to_float()
      3.7
      iex> FinancialSystem.CurrencyConvert.convert_from_USD("EUR", 1) |> Decimal.to_float()
      0.85
  """
  @spec convert_from_USD(any(), binary() | integer() | Decimal.t()) :: Decimal.t()
  def convert_from_USD(account_code, value) do
    currency_rate()["quotes"]["USD#{account_code}"]
    |> FinHelpers.to_decimal()
    |> Decimal.mult(value)
    |> Decimal.round(2)
  end

  @doc """
  Convert value from others.
  ## Example
      iex> FinancialSystem.CurrencyConvert.convert_from_others("BRL", Decimal.add(1,0), "EUR") |> Decimal.to_float()
      0.23
      iex> FinancialSystem.CurrencyConvert.convert_from_others("EUR", Decimal.add(1,0), "BRL") |> Decimal.to_float()
      4.37
  """
  @spec convert_from_others(any(), binary() | integer() | Decimal.t(), any()) :: Decimal.t()
  def convert_from_others(code, value, account_code) do
    code = FinHelpers.to_decimal(currency_rate()["quotes"]["USD#{code}"])
    account_code = FinHelpers.to_decimal(currency_rate()["quotes"]["USD#{account_code}"])

    value
    |> Decimal.div(code)
    |> Decimal.mult(account_code)
    |> Decimal.round(2)
  end

  @doc """
  Check if the currency is valid.
  ## Example
      iex> FinancialSystem.CurrencyConvert.currency_is_valid?("BRL", true)
      true
  """
  @spec currency_is_valid?(binary(), any()) :: any()
  def currency_is_valid?(currency, func) do
    currency = String.upcase(currency)

    if Map.has_key?(currency_rate()["quotes"], "USD#{currency}") do
      func
    else
      raise(ArgumentError, message: "invalid currency.")
    end
  end
end
