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
  def currency_is_valid?(currency, func) do
    currency = String.upcase(currency)

    if Map.has_key?(currency_rate()["quotes"], "USD#{currency}") do
      func
    else
      raise(ArgumentError, message: "invalid currency.")
    end
  end
end
