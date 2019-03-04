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

    decimal_value =
      Decimal.add(1, 0)
      |> FinancialSystem.CurrencyConvert.convert("USD", "BRL")

    assert decimal_value == brl_value
  end
end
