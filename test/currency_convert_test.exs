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

  test "convert currency from usd to others" do
    eur_value =
      FinancialSystem.CurrencyConvert.currency_rate()["quotes"]["USDEUR"]
      |> Decimal.from_float()
      |> Decimal.round(2)

    convert_from_usd = FinancialSystem.CurrencyConvert.convert_from_USD("EUR", 1)

    assert convert_from_usd == eur_value
  end

  test "convert currency from others to others" do
    value_test = Decimal.add(1, 0)

    convert_from_others =
      FinancialSystem.CurrencyConvert.convert_from_others("EUR", value_test, "BRL")
      |> Decimal.to_float()

    assert convert_from_others == 4.37
  end

  test "check if currency is valid" do
    currency_is_valid = FinancialSystem.CurrencyConvert.currency_is_valid?("brl", true)

    assert currency_is_valid == true
  end
end
