defmodule CurrencyTest do
  use ExUnit.Case
  doctest FinancialSystem.Currency

  describe "to_decimal/1" do
    test "User should be able transform a value in integer type to decimal type" do
      assert FinancialSystem.Currency.to_decimal(1) == Decimal.new(1)
    end

    test "User should be able transform a value in float type to decimal type" do
      assert FinancialSystem.Currency.to_decimal(10.0) == Decimal.from_float(10.0)
    end

    test "User not should be able to transform in decimal if you use string type" do
      assert_raise ArgumentError, "Arg must be a integer or float.", fn ->
        FinancialSystem.Currency.to_decimal("10.0")
      end
    end
  end

  describe "currency_is_valid/1" do
    test "User should be able to verify if the currency is valid in upcase" do
      assert FinancialSystem.Currency.currency_is_valid("BRL")
    end

    test "User should be able to verify if the currency is valid in low case" do
      assert FinancialSystem.Currency.currency_is_valid("brl")
    end

    test "User should be able to verify if the currency is not valid" do
      assert_raise ArgumentError,
                   "The currency is not valid. Please, check it and try again.",
                   fn ->
                     FinancialSystem.Currency.currency_is_valid("BRLL")
                   end
    end
  end

  describe "convert/3" do
    test "User should be able to convert the integer value based in currency" do
      assert FinancialSystem.Currency.convert("USD", "BRL", 1) == 370
    end

    test "User should be able to convert the float value based in currency" do
      assert FinancialSystem.Currency.convert("USD", "BRL", 1.0) == 370
    end

    test "User not should be able to convert the value if insert a string" do
      assert_raise ArgumentError, "Check the parameters what are passed to the function.", fn ->
        FinancialSystem.Currency.convert("USD", "BRL", "1")
      end
    end

    test "User not should be able to convert the value with a invalid currency in first parameter" do
      assert_raise ArgumentError,
                   "The currency is not valid. Please, check it and try again.",
                   fn ->
                     FinancialSystem.Currency.convert("BRLL", "BRL", 1)
                   end
    end

    test "User not should be able to convert the value with a invalid currency in second parameter" do
      assert_raise ArgumentError,
                   "The currency is not valid. Please, check it and try again.",
                   fn ->
                     FinancialSystem.Currency.convert("USD", "BRRL", 1)
                   end
    end
  end

  describe "amount_do/3" do
    test "User should be able to transform a integer value in integer to store the value in state" do
      assert FinancialSystem.Currency.amount_do(:store, 1, "USD") == 100
    end

    test "User should be able to transform a float value in integer to store the value in state" do
      assert FinancialSystem.Currency.amount_do(:store, 1.0, "BTC") == 100_000_000
    end

    test "User should be able to transform a integer value in decimal to show the value to user" do
      assert FinancialSystem.Currency.amount_do(:show, 1.0, "BTC") ==
               Decimal.new(1) |> Decimal.div(Kernel.trunc(:math.pow(10, 8))) |> Decimal.round(8)
    end

    test "User should be able to transform a float value in decimal to show the value to user" do
      assert FinancialSystem.Currency.amount_do(:show, 1, "BTC") ==
               Decimal.new(1) |> Decimal.div(Kernel.trunc(:math.pow(10, 8))) |> Decimal.round(8)
    end

    test "User not should be able to transform a value with a invalid value" do
      assert_raise ArgumentError,
                   "The first arg must be :store or :show, second arg must be a number and third must be a valid currency",
                   fn ->
                     FinancialSystem.Currency.amount_do(:show, -1, "BTC")
                   end
    end

    test "User not should be able to transform a value with a invalid operation" do
      assert_raise ArgumentError,
                   "The first arg must be :store or :show, second arg must be a number and third must be a valid currency",
                   fn ->
                     FinancialSystem.Currency.amount_do(":show", 1, "BTC")
                   end
    end

    test "User not should be able to transform a value with a invalid currency" do
      assert_raise ArgumentError,
                   "The currency is not valid. Please, check it and try again.",
                   fn ->
                     FinancialSystem.Currency.amount_do(:show, 1, "BBTC")
                   end
    end
  end
end
