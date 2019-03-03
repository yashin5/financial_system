defmodule FinancialSystem.CurrencyConvert do
  alias FinancialSystem.FinHelpers, as: FinHelpers

  def currency_rate() do
    # Getting currency list
    case File.read("currency_rate.json") do
      {:ok, body} -> Poison.decode!(body)
      {:error, _reason} -> {:error}
    end
  end

  def convert(value, code, account_code) do
    code = String.upcase(code)
    account_code = String.upcase(account_code)

    if currency_is_valid?(code, true) and
         currency_is_valid?(account_code, true) and value > Decimal.add(0, 0) do
      if code == "USD" do
        convert_to_USD(account_code, value)
      else
        convert_to_others(code, value, account_code)
      end
    else
      raise(ArgumentError, message: "invalid value")
    end
  end

  def convert_to_USD(account_code, value) do
    currency_rate()["quotes"]["USD#{account_code}"]
    |> FinHelpers.to_decimal()
    |> Decimal.mult(value)
    |> Decimal.round(2)
  end

  def convert_to_others(code, value, account_code) do
    code = FinHelpers.to_decimal(currency_rate()["quotes"]["USD#{code}"])
    account_code = FinHelpers.to_decimal(currency_rate()["quotes"]["USD#{account_code}"])

    Decimal.div(value, code)
    |> Decimal.mult(account_code)
    |> Decimal.round(2)
  end

  def currency_is_valid?(currency, func) do
    currency = String.upcase(currency)

    if Map.has_key?(currency_rate()["quotes"], "USD#{currency}") do
      func
    else
      raise(ArgumentError, message: "invalid currency.")
    end
  end
end
