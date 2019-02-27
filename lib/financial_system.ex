defmodule FinancialSystem do
  @moduledoc false  # TODO
  
  alias FinancialSystem.UserStruct, as: UserStruct

  def create_user(name, email, currency, initial_value) do
    %UserStruct{name: name, email: email, currency: String.upcase(currency), value: initial_value}
  end

  def deposit(%UserStruct{value: value} = account, deposit_amount) when deposit_amount > 0 do
    new_value = value + deposit_amount
    
    %UserStruct{account | value: new_value}
  end

  def transfer(%UserStruct{value: value_from} = account_from,
    %UserStruct{value: value_to} = account_to, transfer_amount) 
    when value_from >= transfer_amount and transfer_amount > 0 do
    
    new_value_from = value_from - transfer_amount 
    new_value_to = transfer_amount + value_to

    %UserStruct{account_to | value: new_value_to}
    %UserStruct{account_from | value: new_value_from}
  end

  def split()
end
