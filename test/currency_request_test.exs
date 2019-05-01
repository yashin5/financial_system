defmodule CurrencyRequestTest do
  use ExUnit.Case
  doctest FinancialSystem.Currency.CurrencyRequest

  describe "currency_is_valid/1" do
    test "User should be able to verify if the currency is valid or not" do
      assert FinancialSystem.Currency.CurrencyRequest.currency_is_valid("brl") == {:ok, "BRL"}
    end

    test "User should be able to verify if the currency is not valid" do
      assert_raise ArgumentError,
                   "The currency is not valid. Please, check it and try again.",
                   fn ->
                     FinancialSystem.Currency.CurrencyRequest.currency_is_valid("brll")
                   end
    end

    test "User not should be able to verify inserting a arg in blank" do
      assert_raise FunctionClauseError, fn ->
        FinancialSystem.Currency.CurrencyRequest.currency_is_valid("")
      end
    end
  end

  describe "get_from_currency/2" do
    test "User should be able to get a decimal places of a currency" do
      assert FinancialSystem.Currency.CurrencyRequest.get_from_currency(:precision, "BRL") == 2
    end

    test "User not should be able to get a current value of a currency with a currency in blank" do
      assert_raise FunctionClauseError, fn ->
        FinancialSystem.Currency.CurrencyRequest.get_from_currency(:precision, "")
      end
    end

    test "User not should be able to get a decimal places with a invalid currency" do
      assert_raise ArgumentError,
                   "The currency is not valid. Please, check it and try again.",
                   fn ->
                     FinancialSystem.Currency.CurrencyRequest.get_from_currency(
                       :precision,
                       "BRLL"
                     )
                   end
    end

    test "User not should be able to get a current value of a currency with a invalid atom" do
      assert_raise FunctionClauseError, fn ->
        FinancialSystem.Currency.CurrencyRequest.get_from_currency(:precisione, "BRL")
      end
    end

    test "User should be able to get a current value of a currency" do
      assert FinancialSystem.Currency.CurrencyRequest.get_from_currency(:value, "BRL") == 3.702199
    end

    test "User not should be able to get a current value of a currency with a invalid currency" do
      assert_raise ArgumentError,
                   "The currency is not valid. Please, check it and try again.",
                   fn ->
                     FinancialSystem.Currency.CurrencyRequest.get_from_currency(:value, "BRLL")
                   end
    end

    test "User not should be able to get a current value of a currency with a invalid atom2" do
      assert_raise FunctionClauseError, fn ->
        FinancialSystem.Currency.CurrencyRequest.get_from_currency(:valuee, "BRL")
      end
    end

    test "User not should be able to get a current value of a currency with a invalid currency in blank" do
      assert_raise FunctionClauseError, fn ->
        FinancialSystem.Currency.CurrencyRequest.get_from_currency(:value, "")
      end
    end
  end
end
