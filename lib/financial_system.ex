defmodule FinancialSystem do
  @moduledoc false  # TODO
  
  def create_user(name, email, currency, initial_value) do
    %FinancialSystem.UserStruct{name: name, email: email, currency: currency, value: initial_value}
  end

  def deposit(%FinancialSystem.UserStruct{value: value} = account, deposit_amount) when deposit_amount > 0 do
    new_value = value + deposit_amount
    
    %FinancialSystem.UserStruct{account | value: new_value}
  end
end
