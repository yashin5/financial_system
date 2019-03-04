defmodule CurrencyConvert do
  use ExUnit.Case
  doctest FinancialSystem.CurrencyConvert

  test "get the currency rate from json file" do
    currency_rate = Map.to_list(FinancialSystem.CurrencyConvert.currency_rate()["quotes"])
    assert :erlang.length(currency_rate) == 168
  end
end
