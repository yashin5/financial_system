defmodule FinancialSystem do
  use GenServer
  alias FinancialSystem.AccountDefinition, as: AccountDefinition
  alias FinancialSystem.AccountState, as: AccountState

  def create(%AccountDefinition{
    name: name, currency: currency, value: value} = account)
     when is_binary(name) and is_binary(currency) and is_number(value) do
      account
      |> AccountState.start()
  end

  def create(%AccountDefinition{name: name, currency: currency, value: value}) when not is_binary(name) or not is_binary(currency) or not is_number(value) do
    IO.inspect("Name - #{name} and Currency - #{currency} must be a string and Value - #{value} must be a number.")
  end

  def create(_state), do: "Please use the correct data struct."

  def show(pid) do
    Gen
  end

  def deposit() do
  end

  def withdraw() do
  end

  def transfer() do
  end

  def split() do
  end
end
