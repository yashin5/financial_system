defmodule FinancialSystem do
  @moduledoc false  # TODO
  
  def create_user(name, email, currency, initial_value) do
    %FinancialSystem.UserStruct{name: name, email: email, currency: currency, value: initial_value}
  end

  def deposit(%FinancialSystem.UserStruct{value: value} = account, deposit_amount) when deposit_amount > 0 do
    new_value = value + deposit_amount
    
    %FinancialSystem.UserStruct{account | value: new_value}
  end

  def transfer(%FinancialSystem.UserStruct{value: value_from} = account_from,
    %FinancialSystem.UserStruct{value: value_to} = account_to, transfer_amount) 
    when value_from >= transfer_amount and transfer_amount > 0 do
    
    new_value_from = value_from - transfer_amount 
    new_value_to = transfer_amount + value_to

    %FinancialSystem.UserStruct{account_to | value: new_value_to}
    %FinancialSystem.UserStruct{account_from | value: new_value_from}
  end
end
