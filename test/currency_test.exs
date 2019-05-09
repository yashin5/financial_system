defmodule CurrencyTest do
  use ExUnit.Case
  doctest FinancialSystem.Currency

  describe "to_decimal/1" do
    test "User should be able transform a value in integer type to decimal type" do
      assert FinancialSystem.Currency.to_decimal(10) == Decimal.new(10)
    end

    test "User should be able transform a value in float type to decimal type" do
      assert FinancialSystem.Currency.to_decimal(10.0) == Decimal.from_float(10.0)
    end

    test "User not should be able to transform in decimal if you use string type" do
      assert FinancialSystem.Currency.to_decimal("10.0") == {:ok, Decimal.new("10.0")}
    end
  end

  describe "convert/3" do
    test "User should be able to convert the value in number in type string." do
      assert FinancialSystem.Currency.convert("USD", "BRL", "1.0")
    end

    test "User not should be able to convert the value if insert a float" do
      assert_raise ArgumentError,
                   "The first and second args must be a valid currencys and third arg must be a number in string type.",
                   fn ->
                     FinancialSystem.Currency.convert("USD", "BRL", 1.0)
                   end
    end

    test "User not should be able to convert the value if insert a integer" do
      assert_raise ArgumentError,
                   "The first and second args must be a valid currencys and third arg must be a number in string type.",
                   fn ->
                     FinancialSystem.Currency.convert("USD", "BRL", 1)
                   end
    end

    test "User not should be able to convert the value with a invalid currency in first parameter" do
      {:error, message} = FinancialSystem.Currency.convert("BRLL", "BRL", "1")
      assert ^message = "The currency is not valid. Please, check it and try again."
    end

    test "User not should be able to convert the value with a invalid currency in second parameter" do
      {:error, message} = FinancialSystem.Currency.convert("USD", "BRRL", "1")
      assert ^message = "The currency is not valid. Please, check it and try again."
    end
  end

  describe "amount_do/3" do
    test "User should be able to transform a number in string type in integer to store the value in state" do
      assert FinancialSystem.Currency.amount_do(:store, "1.0", "BTC") == {:ok, 100_000_000}
    end

    test "User not should be able to transform a value inserting a number in integer type" do
      assert_raise ArgumentError,
                   "The first arg must be :store or :show, second arg must be a number and third must be a valid currency",
                   fn ->
                     FinancialSystem.Currency.amount_do(:store, 1, "BTC")
                   end
    end

    test "User not should be able to transform a value inserting a number in float type" do
      assert_raise ArgumentError,
                   "The first arg must be :store or :show, second arg must be a number and third must be a valid currency",
                   fn ->
                     FinancialSystem.Currency.amount_do(:store, 1.0, "BTC")
                   end
    end

    test "User not should be able to transform a value inserting a invalid atom" do
      assert_raise ArgumentError,
                   "The first arg must be :store or :show, second arg must be a number and third must be a valid currency",
                   fn ->
                     FinancialSystem.Currency.amount_do(:stores, "1.0", "BTC")
                   end
    end

    test "User not should be able to transform a value inserting a invalid currency" do
      {:error, message} = FinancialSystem.Currency.amount_do(:store, "1.0", "BTCC")

      assert ^message = "The currency is not valid. Please, check it and try again."
    end

    test "User should be able to transform a integer value in decimal to show the value to user" do
      assert FinancialSystem.Currency.amount_do(:show, 1.0, "BTC") == "1E-8"
    end

    test "User should be able to transform a float value in decimal to show the value to user" do
      assert FinancialSystem.Currency.amount_do(:show, 1, "BTC") == "1E-8"
    end

    test "User not should be able to transform a value with a value less than 0" do
      assert_raise ArgumentError,
                   "The first arg must be :store or :show, second arg must be a number and third must be a valid currency",
                   fn ->
                     FinancialSystem.Currency.amount_do(:show, -1, "BTC")
                   end
    end

    test "User not should be able to transform a value with a invalid atomn" do
      assert_raise ArgumentError,
                   "The first arg must be :store or :show, second arg must be a number and third must be a valid currency",
                   fn ->
                     FinancialSystem.Currency.amount_do(":show", 1, "BTC")
                   end
    end

    test "User not should be able to transform a value with a invalid currency" do
      {:error, message} = FinancialSystem.Currency.amount_do(:show, 1, "BBTC")

      assert ^message = "The currency is not valid. Please, check it and try again."
    end
  end
end
