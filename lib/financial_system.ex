defmodule FinancialSystem do
  use GenServer

  alias FinancialSystem.AccountDefinition, as: AccountDefinition
  alias FinancialSystem.AccountState, as: AccountState
  alias FinancialSystem.Currency, as: Currency
  alias FinancialSystem.FinHelper, as: FinHelper
  alias FinancialSystem.SplitDefinition, as: SplitDefinition

  def create(name, currency, value)
     when is_binary(name) and is_binary(currency) and is_number(value) == value > 0 do
      with {:ok, currency_upcase} <- Currency.currency_is_valid?(currency) do
        %AccountDefinition{ name: name, currency: currency_upcase, value: value }
        |> AccountState.start()
      else
        {:error, message} -> message
      end
  end

  def create(name, currency, value) do
    raise(ArgumentError, message: "Name -> #{name} <- and Currency -> #{currency} <- must be a string and Value -> #{value} <- must be a number greater than 0.")
  end

  def show(pid) when is_pid(pid) do
    GenServer.call(pid, :get_data).value
    |> FinHelper.to_decimal("USD#{GenServer.call(pid, :get_data).currency}")
  end

  def show(_), do: raise(ArgumentError, message: "Please insert a valid PID")

  def deposit(pid, currency_from, value) when is_pid(pid) and is_number(value) == value > 0 do
    with {:ok, _} <- Currency.currency_is_valid?(currency_from) do
      converted_value =
        Currency.convert(currency_from, GenServer.call(pid, :get_data).currency, value)

      GenServer.cast(pid, {:deposit, converted_value})
      GenServer.call(pid, :get_data)
    end
  else
    {:error, message} -> message
  end

  def deposit(_, _), do: raise(ArgumentError, message: "The first arg must be a pid and de second arg must be a number")

  def withdraw(pid, value) when is_pid(pid) and is_number(value) == value > 0 do
    with {:ok, _} <- funds?(pid, value) do
      GenServer.cast(pid, {:withdraw, value})
      GenServer.call(pid, :get_data)
    else
      {:error, message} -> message
    end
  end

  def withdraw(_, _), do: raise(ArgumentError, message: "The first arg must be a pid and de second arg must be a number")

  def transfer(value, pid_from, pid_to)
    when is_pid(pid_from) and is_pid(pid_to) and is_number(value) == value > 0 do
    with {:ok, _} <- funds?(pid_from, value) do
      GenServer.cast(pid_from, {:withdraw, value})

      converted_value =
        Currency.convert(
          GenServer.call(pid_from, :get_data).currency,
          GenServer.call(pid_to, :get_data).currency, value)

      GenServer.cast(pid_to, {:deposit, converted_value})
      GenServer.call(pid_to, :get_data)
    else
      {:error, message} -> message
    end
  end

  def transfer(_, _, _), do: raise(ArgumentError, message: "The second and third args must be a pid and de first arg must be a number")

  def split(pid_from, split_list, value)
    when is_pid(pid_from) and is_list(split_list) and is_number(value) == value > 0 do
    with {:ok, _} <- funds?(pid_from, value),
         {:ok, _} <- percent_ok?(split_list),
         {:ok, _} <- split_list_have_account_from?(pid_from, split_list) do

      split_list
      |> unite_equal_account_split()
      |> Enum.map(fn %SplitDefinition{account: pid_to, percent: percent} ->

        percent / 100 * value
        |> transfer(pid_from, pid_to)
      end)
    else
      {:error, message} -> message
    end
  end

  def split(_, _), do: raise(ArgumentError, message: "The first arg must be a pid, the second must be a list with %SplitDefinition{} and the third must be a value.")

  def funds?(pid, value) do
    %AccountDefinition{value: value_account} = GenServer.call(pid, :get_data)
      case value_account >= value do
        true -> {:ok, pid}
        false -> {:error, raise(ArgumentError, message: "Does not have the necessary funds")}
      end
  end

  def split_list_have_account_from?(account_from, split_list) when is_pid(account_from) and is_list(split_list) do
    have_or_not = split_list
      |> Enum.map(fn %SplitDefinition{account: account_to} -> account_from == account_to end)
      |> Enum.member?(true)

    case have_or_not do
      false -> {:ok, false}
      true -> {:error, raise(ArgumentError, message: "You can not send to the same account as you are sending")}
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

  def unite_equal_account_split(split_list) do
    split_list
    |> Enum.reduce(%{}, fn %FinancialSystem.SplitDefinition{
    account: account, percent: percent} = sp, acc ->
       Map.update(acc, account,sp, fn acc ->%{acc | percent: acc.percent + sp.percent}
       end)
    end)
    |> Enum.map(fn {_, resp} -> resp end)
  end
end
