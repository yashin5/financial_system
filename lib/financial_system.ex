defmodule FinancialSystem do

  alias FinancialSystem.AccountDefinition, as: AccountDefinition

  def create(%AccountDefinition{
    name: name, currency: currency, value: value} = state)
     when is_binary(name) and is_binary(currency) and is_number(value) do

  end

  def create(%AccountDefinition{name: name}) when not is_binary(name) do
    IO.inspect("Name - #{name} - must be a string.")
  end

  def create(%AccountDefinition{currency: currency}) when not is_binary(currency) do
    IO.inspect("Currency - #{currency} - must be a string.")
  end

  def create(%AccountDefinition{value: value}) when not is_number(value) do
    IO.inspect("Value - #{value} - must be a number.")
  end

  def create(_state), do: "Please use the correct data struct."

  def show() do
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
