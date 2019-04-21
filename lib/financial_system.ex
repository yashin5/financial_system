defmodule FinancialSystem do
  use GenServer

  alias FinancialSystem.AccountDefinition, as: AccountDefinition
  alias FinancialSystem.AccountState, as: AccountState
  alias FinancialSystem.Currency, as: Currency
  alias FinancialSystem.FinHelper, as: FinHelper
  alias FinancialSystem.SplitDefinition, as: SplitDefinition

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

  @spec deposit(pid(), String.t(), number()) :: struct() | {:error, String.t()}
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

  @spec withdraw(pid(), number()) :: struct() | {:error, String.t()}
  def withdraw(pid, value) when is_pid(pid) and is_number(value) == value > 0 do
    with true <- funds?(pid, value) do
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

  @spec transfer(number(), pid(), pid()) :: struct() | {:error, String.t()}
  def transfer(value, pid_from, pid_to)
      when is_pid(pid_from) and is_pid(pid_to) and is_number(value) == value > 0 do
    with true <- funds?(pid_from, value) do
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

  @spec split(pid(), maybe_improper_list(), any()) :: [any()]
  def split(pid_from, split_list, value)
      when is_pid(pid_from) and is_list(split_list) and is_number(value) == value > 0 do
    with true <- funds?(pid_from, value),
         true <- percent_ok?(split_list),
         false <- split_list_have_account_from?(pid_from, split_list) do
      split_list
      |> unite_equal_account_split()
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

  @spec funds?(pid(), number()) :: true
  def funds?(pid, value) do
    case GenServer.call(pid, :get_data).value >= value do
      true -> true
      false -> {:error, raise(ArgumentError, message: "Does not have the necessary funds")}
    end
  end

  @spec split_list_have_account_from?(pid(), list(struct())) :: false | {:error, String.t()}
  def split_list_have_account_from?(account_from, split_list)
      when is_pid(account_from) and is_list(split_list) do
    have_or_not =
      split_list
      |> Enum.map(fn %SplitDefinition{account: account_to} -> account_from == account_to end)
      |> Enum.member?(true)

    case have_or_not do
      false ->
        false

      true ->
        {:error,
         raise(ArgumentError, message: "You can not send to the same account as you are sending")}
    end
  end

  @spec percent_ok?(list(struct())) :: boolean() | {:error, String.t()}
  def percent_ok?(split_list) do
    total_percent =
      split_list
      |> Enum.reduce(0, fn %SplitDefinition{percent: percent}, acc ->
        acc + percent
      end)

    case total_percent == 100 do
      true -> true
      false -> {:error, raise(ArgumentError, message: "The total percent must be 100.")}
    end
  end

  @spec unite_equal_account_split(list(struct())) :: list(struct)
  def unite_equal_account_split(split_list) do
    split_list
    |> Enum.reduce(%{}, fn %FinancialSystem.SplitDefinition{account: account} = sp, acc ->
      Map.update(acc, account, sp, fn acc -> %{acc | percent: acc.percent + sp.percent} end)
    end)
    |> Enum.map(fn {_, resp} -> resp end)
  end
end
