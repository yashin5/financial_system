defmodule CurrencyConvert do
  use ExUnit.Case
  doctest FinancialSystem.CurrencyConvert

  test "get the currency rate from json file" do
    currency_rate = Map.to_list(FinancialSystem.CurrencyConvert.currency_rate()["quotes"])

    assert :erlang.length(currency_rate) == 168
  end

  test "perform value conversion" do
    brl_value =
      FinancialSystem.CurrencyConvert.currency_rate()["quotes"]["USDBRL"]
      |> Decimal.from_float()
      |> Decimal.round(2)

    convert =
      Decimal.add(1, 0)
      |> FinancialSystem.CurrencyConvert.convert("USD", "BRL")

    assert convert == brl_value
  end

  test "convert currency for usd" do
    eur_value =
      FinancialSystem.CurrencyConvert.currency_rate()["quotes"]["USDEUR"]
      |> Decimal.from_float()
      |> Decimal.round(2)

    convert_from_usd = FinancialSystem.CurrencyConvert.convert_from_USD("EUR", 1)

    assert convert_from_usd == eur_value
  end
end
