defmodule FinancialSystem.FinHelpers do
  @moduledoc """
  This module is responsable for helper other modules with
  add, subtract and transform values to decimal.
  """
  alias FinancialSystem.Account, as: Account
  alias FinancialSystem.CurrencyConvert, as: CurrencyConvert

  @doc """
  Subtract value from account.
  ## Example
      iex> account1 = FinancialSystem.CreateAccount.create_user("This", "is@email.com", "BRL", 100)
      iex> FinancialSystem.FinHelpers.subtracts_value(account1, account1.value, 50)
      %FinancialSystem.Account{currency: "BRL", email: "is@email.com", name: "This", value: Decimal.add(50,0) |> Decimal.round(1)}
  """
  def subtracts_value(account_from, value_from, action_amount) do
    if Decimal.to_float(value_from) >= action_amount do
      new_value_from =
        value_from
        |> Decimal.sub(action_amount)

      %Account{account_from | value: new_value_from}
    else
      raise(ArgumentError, message: "This account dont have funds for this operation.")
    end
  end

  @doc """
  Add value in account.
  ## Example
      iex> account1 = FinancialSystem.CreateAccount.create_user("This", "is@email.com", "BRL", 100)
      iex> FinancialSystem.FinHelpers.add_value(account1, account1.value, "BRL", account1.currency, 50)
      %FinancialSystem.Account{currency: "BRL", email: "is@email.com", name: "This", value: Decimal.add(150,0) |> Decimal.round(2)}
  """
  def add_value(account_to, value_to, currency_to, currency_from, action_amount) do
    balance_value = CurrencyConvert.convert(to_decimal(action_amount), currency_to, currency_from)

    new_value_to =
      balance_value
      |> Decimal.add(value_to)
      |> Decimal.round(2)

    %Account{account_to | value: new_value_to}
  end

  @doc """
  Transform the number integer or float in decimal.
  ## Example
      iex> _to_decimal_integer = FinancialSystem.FinHelpers.to_decimal(10)
      Decimal.add(10,0) |> Decimal.round(1)
      iex> _to_decimal_float = FinancialSystem.FinHelpers.to_decimal(10.0)
      Decimal.add(10,0) |> Decimal.round(1)
  """
  def to_decimal(number) when is_number(number) do
    cond do
      is_integer(number) ->
        number = Integer.to_string(number)
        {number, _rest} = Float.parse(number)
        Decimal.from_float(number)

      is_float(number) ->
        Decimal.from_float(number)

      true ->
        raise(ArgumentError, message: "Please use a integer or float value.")
    end
  end
end
