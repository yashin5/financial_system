defmodule CurrencyTest do
  use ExUnit.Case

  import Mox
  setup :verify_on_exit!

  doctest FinancialSystem.Currency

  describe "to_decimal/1" do
    test "User should be able transform a value in integer type to decimal type" do
      {:ok, value} = FinancialSystem.Currency.to_decimal(10)

      assert value == Decimal.new(10)
    end

    test "User should be able transform a value in float type to decimal type" do
      {:ok, value} = FinancialSystem.Currency.to_decimal(10.0)

      assert value == Decimal.from_float(10.0)
    end

    test "User not should be able to transform in decimal if you use string type" do
      assert FinancialSystem.Currency.to_decimal("10.0") == {:ok, Decimal.new("10.0")}
    end
  end

  describe "convert/3" do
    test "User should be able to convert the value in number in type string." do
      expect(CurrencyRequestMock, :load_from_config, 5, fn ->
        %{"decimal" => %{"USDBRL" => 2}, "quotes" => %{"USDBRL" => 3.702199}}
      end)

      assert FinancialSystem.Currency.convert("USD", "BRL", "1.0") == {:ok, 370}
    end

    test "User not should be able to convert the value if insert a float" do
      {:error, message} = FinancialSystem.Currency.convert("USD", "BRL", 1.0)

      assert ^message =
               "The first and second args must be a valid currencys and third arg must be a number in string type."
    end

    test "User not should be able to convert the value if insert a integer" do
      {:error, message} = FinancialSystem.Currency.convert("USD", "BRL", 1)

      assert ^message =
               "The first and second args must be a valid currencys and third arg must be a number in string type."
    end

    test "User not should be able to convert the value with a invalid currency in first parameter" do
      expect(CurrencyRequestMock, :load_from_config, 1, fn ->
        %{"decimal" => %{"USDBRL" => 2}, "quotes" => %{"USDBRL" => 3.702199}}
      end)

      {:error, message} = FinancialSystem.Currency.convert("BRLL", "BRL", "1")

      assert ^message = "The currency is not valid. Please, check it and try again."
    end

    test "User not should be able to convert the value with a invalid currency in second parameter" do
      expect(CurrencyRequestMock, :load_from_config, 1, fn ->
        %{"decimal" => %{"USDBRL" => 2}, "quotes" => %{"USDBRL" => 3.702199}}
      end)

      {:error, message} = FinancialSystem.Currency.convert("USD", "BRRL", "1")

      assert ^message = "The currency is not valid. Please, check it and try again."
    end
  end

  describe "amount_do/3" do
    test "User should be able to transform a number in string type in integer to store the value in state" do
      expect(CurrencyRequestMock, :load_from_config, 3, fn ->
        %{"decimal" => %{"USDBTC" => 8}, "quotes" => %{"USDBTC" => 0.000149}}
      end)

      {_, value} = FinancialSystem.Currency.amount_do(:store, "1.0", "BTC")
      assert  value == 100_000_000
    end

    test "User not should be able to transform a value inserting a number in integer type" do
      {:error, message} = FinancialSystem.Currency.amount_do(:store, 1, "BTC")

      assert ^message =
               "The first arg must be :store or :show, second arg must be a number and third must be a valid currency"
    end

    test "User not should be able to transform a value inserting a number in float type" do
      {:error, message} = FinancialSystem.Currency.amount_do(:store, 1.0, "BTC")

      assert ^message =
               "The first arg must be :store or :show, second arg must be a number and third must be a valid currency"
    end

    test "User not should be able to transform a value inserting a invalid atom" do
      {:error, message} = FinancialSystem.Currency.amount_do(:stores, "1.0", "BTC")

      assert ^message =
               "The first arg must be :store or :show, second arg must be a number and third must be a valid currency"
    end

    test "User not should be able to transform a value inserting a invalid currency" do
      expect(CurrencyRequestMock, :load_from_config, 1, fn ->
        %{"decimal" => %{"USDBTC" => 8}, "quotes" => %{"USDBTC" => 0.000149}}
      end)

      {:error, message} = FinancialSystem.Currency.amount_do(:store, "1.0", "BTCC")

      assert ^message = "The currency is not valid. Please, check it and try again."
    end

    test "User should be able to transform a integer value in decimal to show the value to user" do
      expect(CurrencyRequestMock, :load_from_config, 3, fn ->
        %{"decimal" => %{"USDBTC" => 8}, "quotes" => %{"USDBTC" => 0.000149}}
      end)

      {_, value} = FinancialSystem.Currency.amount_do(:show, 1, "BTC")

      assert value == "1E-8"
    end

    test "User should be able to transform a float value in decimal to show the value to user" do
      expect(CurrencyRequestMock, :load_from_config, 3, fn ->
        %{"decimal" => %{"USDBTC" => 8}, "quotes" => %{"USDBTC" => 0.000149}}
      end)

      {_, value} = FinancialSystem.Currency.amount_do(:show, 1, "BTC")
      assert value == "1E-8"
    end

    test "User not should be able to transform a value with a value less than 0" do
      {:error, message} = FinancialSystem.Currency.amount_do(:show, -1, "BTC")

      assert ^message =
               "The first arg must be :store or :show, second arg must be a number and third must be a valid currency"
    end

    test "User not should be able to transform a value with a invalid atomn" do
      {:error, message} = FinancialSystem.Currency.amount_do(":show", 1, "BTC")

      assert ^message =
               "The first arg must be :store or :show, second arg must be a number and third must be a valid currency"
    end

    test "User not should be able to transform a value with a invalid currency" do
      expect(CurrencyRequestMock, :load_from_config, 1, fn ->
        %{"decimal" => %{"USDBTC" => 8}, "quotes" => %{"USDBTC" => 0.000149}}
      end)

      {:error, message} = FinancialSystem.Currency.amount_do(:show, 1, "BBTC")

      assert ^message = "The currency is not valid. Please, check it and try again."
    end
  end
end
