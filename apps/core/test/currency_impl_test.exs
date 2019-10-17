defmodule CurrencyImplTest do
  use FinancialSystem.Core.DataCase, async: true

  import Mox

  alias FinancialSystem.Core.Currency.CurrencyImpl

  setup :verify_on_exit!

  doctest FinancialSystem.Core.Currency.CurrencyImpl

  describe "currency_is_valid/1" do
    test "Should be able to verify if the currency is valid or not" do
      assert CurrencyImpl.currency_is_valid("brl") == {:ok, "BRL"}
    end

    test "Should be able to verify if the currency is not valid" do
      {:error, message} = CurrencyImpl.currency_is_valid("brll")

      assert ^message = :currency_is_not_valid
    end
  end

  describe "get_from_currency/2" do
    test "Should be able to get a decimal places of a currency" do
      {:ok, decimal_precision} = CurrencyImpl.get_from_currency(:precision, "BRL")

      assert decimal_precision == 2
    end

    test "Not should be able to get a decimal places with a invalid currency" do
      {:error, message} = CurrencyImpl.get_from_currency(:precision, "BRLL")
      assert ^message = :currency_is_not_valid
    end

    test "Should be able to get a current value of a currency" do
      {:ok, currency_value} = CurrencyImpl.get_from_currency(:value, "BRL")

      assert currency_value == 3.702199
    end

    test "Not should be able to get a current value of a currency with a invalid currency" do
      {:error, message} = CurrencyImpl.get_from_currency(:value, "BRLL")

      assert ^message = :currency_is_not_valid
    end
  end

  describe "get_currencies/0" do
    test "Should get all currencies from application" do
      currencies = CurrencyImpl.get_currencies() |> List.first()

      assert currencies == "MZN"
    end
  end
end
