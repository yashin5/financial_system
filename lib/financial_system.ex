defmodule FinancialSystem do
  @moduledoc """
  This module is responsable to implement the financial operations.
  """

  use GenServer

  alias FinancialSystem.AccountDefinition, as: AccountDefinition
  alias FinancialSystem.AccountState, as: AccountState
  alias FinancialSystem.Currency, as: Currency
  alias FinancialSystem.FinHelper, as: FinHelper
  alias FinancialSystem.SplitDefinition, as: SplitDefinition

  @type account :: %AccountDefinition{name: String.t(), currency: String.t(), value: number()}
  @type account_split :: %SplitDefinition{account: account(), percent: number()}

  @spec create(String.t(), String.t(), number()) :: {:ok, pid()} | {:error, String.t()}
  def create(name, currency, value)
      when is_binary(name) and is_binary(currency) and is_number(value) == value > 0 do
    with {:ok, currency_upcase} <- Currency.currency_is_valid?(currency) do
      %AccountDefinition{name: name, currency: currency_upcase, value: value}
      |> AccountState.start()
    else
      {:error, message} -> message
    end
  end

  @spec create(any(), any(), any()) :: String.t()
  def create(name, currency, value) do
    raise(ArgumentError,
      message:
        "Name -> #{name} <- and Currency -> #{currency} <- must be a string and Value -> #{value} <- must be a number greater than 0."
    )
  end

  @spec show(pid()) :: Decimal.t()
  def show(pid) when is_pid(pid) do
    GenServer.call(pid, :get_data).value
    |> FinHelper.to_decimal("USD#{GenServer.call(pid, :get_data).currency}")
  end

  @spec show(any()) :: String.t()
  def show(_), do: raise(ArgumentError, message: "Please insert a valid PID")

  @spec deposit(pid(), String.t(), number()) :: account() | {:error, String.t()}
  def deposit(pid, currency_from, value) when is_pid(pid) and is_number(value) == value > 0 do
    case Currency.currency_is_valid?(currency_from) do
      {:ok, _} ->
        GenServer.cast(
          pid,
          {:deposit,
           Currency.convert(currency_from, GenServer.call(pid, :get_data).currency, value)}
        )

        GenServer.call(pid, :get_data)

      {:error, message} ->
        message
    end
  end

  @spec deposit(any(), any()) :: String.t()
  def deposit(_, _),
    do:
      raise(ArgumentError,
        message: "The first arg must be a pid and de second arg must be a number"
      )

  @spec withdraw(pid(), number()) :: account() | {:error, String.t()}
  def withdraw(pid, value) when is_pid(pid) and is_number(value) == value > 0 do
    with true <- FinHelper.funds?(pid, value) do
      GenServer.cast(pid, {:withdraw, value})
      GenServer.call(pid, :get_data)
    else
      {:error, message} -> message
    end
  end

  @spec withdraw(any(), any()) :: binary()
  def withdraw(_, _),
    do:
      raise(ArgumentError,
        message: "The first arg must be a pid and de second arg must be a number"
      )

  @spec transfer(number(), pid(), pid()) :: account() | {:error, String.t()}
  def transfer(value, pid_from, pid_to)
      when is_pid(pid_from) and is_pid(pid_to) and is_number(value) == value > 0 do
    with true <- FinHelper.funds?(pid_from, value) do
      GenServer.cast(pid_from, {:withdraw, value})

      converted_value =
        Currency.convert(
          GenServer.call(pid_from, :get_data).currency,
          GenServer.call(pid_to, :get_data).currency,
          value
        )

      GenServer.cast(pid_to, {:deposit, converted_value})
      GenServer.call(pid_to, :get_data)
    else
      {:error, message} -> message
    end
  end

  @spec transfer(any(), any(), any()) :: String.t()
  def transfer(_, _, _),
    do:
      raise(ArgumentError,
        message: "The second and third args must be a pid and de first arg must be a number"
      )

  @spec split(pid(), account_split(), number()) :: [account()]
  def split(pid_from, split_list, value)
      when is_pid(pid_from) and is_list(split_list) and is_number(value) == value > 0 do
    with true <- FinHelper.funds?(pid_from, value),
         true <- FinHelper.percent_ok?(split_list),
         false <- FinHelper.split_list_have_account_from?(pid_from, split_list) do
      split_list
      |> FinHelper.unite_equal_account_split()
      |> Enum.map(fn %SplitDefinition{account: pid_to, percent: percent} ->
        (percent / 100 * value)
        |> transfer(pid_from, pid_to)
      end)
    else
      {:error, message} -> message
    end
  end

  @spec split(any(), any()) :: String.t()
  def split(_, _),
    do:
      raise(ArgumentError,
        message:
          "The first arg must be a pid, the second must be a list with %SplitDefinition{} and the third must be a value."
      )
end
