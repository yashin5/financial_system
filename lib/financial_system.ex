defmodule FinancialSystem do
  # TODO

  @moduledoc false

  alias FinancialSystem.Account, as: Account
  alias FinancialSystem.SplitList, as: SplitList

  def create_user(name, email, currency, initial_value) do
    %Account{name: name, email: email, currency: String.upcase(currency), value: initial_value}
  end

  def deposit(%Account{value: value_to} = account_to, deposit_amount) when deposit_amount > 0 do
    add_value(account_to, value_to, deposit_amount)
  end

  def transfer(
        %Account{email: email_from, value: value_from} = account_from,
        %Account{email: email_to, value: value_to} = account_to,
        transfer_amount
      )
      when email_from != email_to and value_from >= transfer_amount and transfer_amount > 0 do
      subtracts_value(account_from, value_from, transfer_amount) 

      add_value(account_to, value_to, transfer_amount)
  end

  def subtracts_value(account_from, value_from, action_amount) do
    new_value_from = value_from - action_amount

    %Account{account_from | value: new_value_from}    
  end

  def add_value(account_to, value_to, action_amount) do
    new_value_to = action_amount + value_to

    %Account{account_to | value: new_value_to}
  end
end