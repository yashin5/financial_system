defmodule FinancialSystem do
  use GenServer

  alias FinancialSystem.AccountDefinition, as: AccountDefinition
  alias FinancialSystem.AccountState, as: AccountState

  def create(%AccountDefinition{
    name: name, currency: currency, value: value} = account)
     when is_binary(name) and is_binary(currency) and is_number(value) == value > 0 do
      account
      |> AccountState.start()
  end

  def create(%AccountDefinition{name: name, currency: currency, value: value}) when not is_binary(name) or not is_binary(currency) or not is_number(value) do
    "Name - #{name} and Currency - #{currency} must be a string and Value - #{value} must be a number and greater than 0."
  end

  def create(_), do: "Please use the correct data struct."

  def show(pid) when is_pid(pid) do
    GenServer.call(pid, :get_data)
  end

  def show(_), do: "Please insert a valid PID"

  def deposit(pid, value) when is_pid(pid) and is_number(value) do
    GenServer.cast(pid, {:deposit, value})
    GenServer.call(pid, :get_data)
  end

  def deposit(_, _), do: "The first arg must be a pid and de second arg must be a number"

  def withdraw(pid, value) when is_pid(pid) and is_number(value) do
    with {:ok, pid_ok} <- funds?(pid, value) do
      GenServer.cast(pid_ok, {:withdraw, value})
      GenServer.call(pid_ok, :get_data)
    else
      {:error, message} -> message
    end
  end

  def withdraw(_, _), do: "The first arg must be a pid and de second arg must be a number"

  def transfer() do
  end

  def split() do
  end

  def funds?(pid, value) do
    %AccountDefinition{
      name: _, currency: _, value: value_account} = GenServer.call(pid, :get_data)
      case value_account >= value do
        true -> {:ok, pid}
        false -> {:error, "Does not have the necessary funds"}
      end
  end
end
