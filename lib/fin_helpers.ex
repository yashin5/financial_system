defmodule FinancialSystem.FinHelpers do
  alias FinancialSystem.Account, as: Account
  alias FinancialSystem.CurrencyConvert, as: CurrencyConvert

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

  def add_value(account_to, value_to, currency_to, currency_from, action_amount) do
    balance_value = CurrencyConvert.convert(to_decimal(action_amount), currency_to, currency_from)

    new_value_to =
      Decimal.add(balance_value, value_to)
      |> Decimal.round(2)

    %Account{account_to | value: new_value_to}
  end

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
