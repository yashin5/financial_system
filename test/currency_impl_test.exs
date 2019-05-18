defmodule CurrencyImplTest do
  use ExUnit.Case

  import Mox
  setup :verify_on_exit!

  doctest FinancialSystem.Currency.CurrencyImpl

  describe "currency_is_valid/1" do
    test "User should be able to verify if the currency is valid or not" do
      expect(CurrencyRequestMock, :load_from_config, 1, fn ->
        %{"quotes" => %{"USDBRL" => 3.702199}}
      end)

      assert FinancialSystem.Currency.CurrencyImpl.currency_is_valid("brl") == {:ok, "BRL"}
    end

    test "User should be able to verify if the currency is not valid" do
      expect(CurrencyRequestMock, :load_from_config, 1, fn ->
        %{"quotes" => %{"USDBRL" => 3.702199}}
      end)

      {:error, message} = FinancialSystem.Currency.CurrencyImpl.currency_is_valid("brll")

      assert ^message = "The currency is not valid. Please, check it and try again."
    end
  end

  describe "get_from_currency/2" do
    test "User should be able to get a decimal places of a currency" do
      expect(CurrencyRequestMock, :load_from_config, 2, fn ->
        %{"decimal" => %{"USDBRL" => 2}, "quotes" => %{"USDBRL" => 3.702199}}
      end)

      {_, decimal_precision} = FinancialSystem.Currency.CurrencyImpl.get_from_currency(:precision, "BRL")

      assert decimal_precision == 2
    end

    test "User not should be able to get a decimal places with a invalid currency" do
      expect(CurrencyRequestMock, :load_from_config, 1, fn ->
        %{"quotes" => %{"USDBRL" => 3.702199}}
      end)

      {:error, message} =
        FinancialSystem.Currency.CurrencyImpl.get_from_currency(:precision, "BRLL")

      assert ^message = "The currency is not valid. Please, check it and try again."
    end

    test "User should be able to get a current value of a currency" do
      expect(CurrencyRequestMock, :load_from_config, 2, fn ->
        %{"quotes" => %{"USDBRL" => 3.702199}}
      end)

      {_, currency_value} = FinancialSystem.Currency.CurrencyImpl.get_from_currency(:value, "BRL")

      assert currency_value == 3.702199
    end

    test "User not should be able to get a current value of a currency with a invalid currency" do
      expect(CurrencyRequestMock, :load_from_config, 1, fn ->
        %{"quotes" => %{"USDBRL" => 3.702199}}
      end)

      {:error, message} = FinancialSystem.Currency.CurrencyImpl.get_from_currency(:value, "BRLL")

      assert ^message = "The currency is not valid. Please, check it and try again."
    end
  end
end
