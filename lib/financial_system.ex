defmodule FinancialSystem do
  use GenServer

  alias FinancialSystem.AccountDefinition, as: AccountDefinition
  alias FinancialSystem.AccountState, as: AccountState
  alias FinancialSystem.SplitDefinition, as: SplitDefinition

  def create(%AccountDefinition{
    name: name, currency: currency, value: value} = account)
     when is_binary(name) and is_binary(currency) and is_number(value) == value > 0 do
      account
      |> AccountState.start()
  end

  def create(%AccountDefinition{name: name, currency: currency, value: value}) do
    raise(ArgumentError, message: "Name -> #{name} <- and Currency -> #{currency} <- must be a string and Value -> #{value} <- must be a number greater than 0.")
  end

  def create(_), do: raise(ArgumentError, message: "Please use the correct data struct.")

  def show(pid) when is_pid(pid) do
    GenServer.call(pid, :get_data)
  end

  def show(_), do: raise(ArgumentError, message: "Please insert a valid PID")

  def deposit(pid, value) when is_pid(pid) and is_number(value) do
    GenServer.cast(pid, {:deposit, value})
    show(pid)
  end

  def deposit(_, _), do: raise(ArgumentError, message: "The first arg must be a pid and de second arg must be a number")

  def withdraw(pid, value) when is_pid(pid) and is_number(value) do
    with {:ok, _} <- funds?(pid, value) do
      GenServer.cast(pid, {:withdraw, value})
      show(pid)
    else
      {:error, message} -> message
    end
  end

  def withdraw(_, _), do: raise(ArgumentError, message: "The first arg must be a pid and de second arg must be a number")

  def transfer(value, pid_from, pid_to)
    when is_pid(pid_from) and is_pid(pid_to) and is_number(value) do
    with {:ok, _} <- funds?(pid_from, value) do
      GenServer.cast(pid_from, {:withdraw, value})

      GenServer.cast(pid_to, {:deposit, value})
      show(pid_to)
    else
      {:error, message} -> message
    end
  end

  def transfer(_, _, _), do: raise(ArgumentError, message: "The second and third args must be a pid and de first arg must be a number")

  def split(pid_from, split_list, value)
    when is_pid(pid_from) and is_list(split_list) and is_number(value) do
    with {:ok, _} <- funds?(pid_from, value),
         {:ok, _} <- percent_ok?(split_list) do

      split_list
      |> unite_qual_account_split()
      |> Enum.map(fn %SplitDefinition{account: pid_to, percent: percent} ->

        percent / 100 * value
        |> transfer(pid_from, pid_to)
      end)
    else
      {:error, message} -> message
    end
  end

  def funds?(pid, value) do
    %AccountDefinition{
      name: _, currency: _, value: value_account} = GenServer.call(pid, :get_data)
      case value_account >= value do
        true -> {:ok, pid}
        false -> {:error, raise(ArgumentError, message: "Does not have the necessary funds")}
      end
  end

  def percent_ok?(split_list) do
    total_percent =
      split_list
      |>Enum.reduce(0, fn %SplitDefinition{percent: percent}, acc ->
        acc + percent
      end)

      case total_percent == 100 do
        true -> {:ok, true}
        false -> {:error, raise(ArgumentError, message: "The total percent must be 100.")}
      end
  end

  def unite_qual_account_split(split_list) do
    split_list
    |> Enum.reduce(%{}, fn %FinancialSystem.SplitDefinition{
    account: account, percent: percent} = sp, acc ->
       Map.update(acc, account,sp, fn acc ->%{acc | percent: acc.percent + sp.percent}
       end)
    end)
    |> Enum.map(fn {_, resp} -> resp end)
  end
end
