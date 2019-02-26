defmodule FinancialSystem do
  @moduledoc false
  def create_user(name, email, value) do
    %FinancialSystem.UserStruct{name: name, email: email, value: value}
  end
end
