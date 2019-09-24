defmodule CurrencyTest do
  use FinancialSystem.Core.DataCase, async: true

  import Mox

  alias FinancialSystem.Core.Currency

  setup :verify_on_exit!

  doctest FinancialSystem.Core.Currency

  describe "to_decimal/1" do
    test "Should be able transform a value in integer type to decimal type" do
      {:ok, value} = Currency.to_decimal(10)

      assert value == Decimal.new(10)
    end

    test "Should be able transform a value in float type to decimal type" do
      {:ok, value} = Currency.to_decimal(10.0)

      assert value == Decimal.from_float(10.0)
    end

    test "Not should be able to transform in decimal if you use string type" do
      assert Currency.to_decimal("10.0") == {:ok, Decimal.new("10.0")}
    end
  end

  describe "convert/3" do
    test "Should be able to convert the value in number in type string." do
      assert Currency.convert("USD", "BRL", "1.0") == {:ok, 370}
    end

    test "Not should be able to convert the value if insert a float" do
      {:error, message} = Currency.convert("USD", "BRL", 1.0)

      assert ^message = :invalid_value_type
    end

    test "Not should be able to convert the value if insert a integer" do
      {:error, message} = Currency.convert("USD", "BRL", 1)

      assert ^message = :invalid_value_type
    end

    test "Not should be able to convert the value with a invalid currency in first parameter" do
      {:error, message} = Currency.convert("BRLL", "BRL", "1")

      assert ^message = :currency_is_not_valid
    end

    test "Not should be able to convert the value with a invalid currency in second parameter" do
      {:error, message} = Currency.convert("USD", "BRRL", "1")

      assert ^message = :currency_is_not_valid
    end
  end

  describe "amount_do/3" do
    test "Should be able to transform a number in string type in integer to store the value in state" do
      {:ok, value} = Currency.amount_do(:store, "1.0", "BTC")
      assert value == 100_000_000
    end

    test "Not should be able to transform a value inserting a number in integer type" do
      {:error, message} = Currency.amount_do(:store, 1, "BTC")

      assert ^message = :invalid_value_type
    end

    test "Not should be able to transform a value inserting a number in float type" do
      {:error, message} = Currency.amount_do(:store, 1.0, "BTC")

      assert ^message = :invalid_value_type
    end

    test "Not should be able to transform a value inserting a invalid atom" do
      {:error, message} = Currency.amount_do(:stores, "1.0", "BTC")

      assert ^message = :invalid_arguments_type
    end

    test "Not should be able to transform a value inserting a invalid currency" do
      {:error, message} = Currency.amount_do(:store, "1.0", "BTCC")

      assert ^message = :currency_is_not_valid
    end

    test "Should be able to transform a integer value in decimal to show the value to user" do
      {:ok, value} = Currency.amount_do(:show, 1, "BTC")

      assert value == "1E-8"
    end

    test "Should be able to transform a float value in decimal to show the value to user" do
      {:ok, value} = Currency.amount_do(:show, 1, "BTC")
      assert value == "1E-8"
    end

    test "Not should be able to transform a value with a value less than 0" do
      {:error, message} = Currency.amount_do(:show, -1, "BTC")

      assert ^message = :invalid_value_type
    end

    test "Not should be able to transform a value with a invalid atomn" do
      {:error, message} = Currency.amount_do(":show", 1, "BTC")

      assert ^message = :invalid_arguments_type
    end

    test "Not should be able to transform a value with a invalid currency" do
      {:error, message} = Currency.amount_do(:show, 1, "BBTC")

      assert ^message = :currency_is_not_valid
    end
  end
end
