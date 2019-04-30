defmodule FinancialSystem do
  @moduledoc """
  This module is responsable to implement the financial operations.
  """

  @behaviour FinancialSystem.Financial

  alias FinancialSystem.{Account, AccountState, Currency, FinHelper, Split}
  alias FinancialSystem.Currency.CurrencyBrowser

  @doc """
    Create user accounts

  ## Examples
    FinancialSystem.create("Yashin Santos",  "EUR", 220)
  """
  @impl true
  def create(name, currency, value)
      when is_binary(name) and is_binary(currency) and is_number(value) == value >= 0 do
    with {:ok, currency_upcase} <- CurrencyBrowser.currency_is_valid(currency),
         true <- byte_size(name) > 0 do
      %Account{
        name: name,
        currency: currency_upcase,
        value: Currency.amount_do(:store, value, currency_upcase)
      }
      |> AccountState.start()
    end
  end

  def create(_, _, _) do
    raise(ArgumentError,
      message:
        "First and second args must be a string and third arg must be a number greater than 0."
    )
  end

  @doc """
    Show the value in account.

  ## Examples
    {_, pid} = FinancialSystem.create("Yashin Santos", "EUR", 220)
    FinancialSystem.show(pid)
  """
  @impl true
  def show(pid) when is_pid(pid) do
    Currency.amount_do(
      :show,
      AccountState.show(pid).value,
      AccountState.show(pid).currency
    )
  end

  def show(_), do: raise(ArgumentError, message: "Please insert a valid PID")

  @doc """
    Deposit value in account.

  ## Examples
    {_, pid} = FinancialSystem.create("Yashin Santos", "EUR", 220)
    FinancialSystem.deposit(pid, "BRL", 10)
  """
  @impl true
  def deposit(pid, currency_from, value) when is_pid(pid) and is_number(value) == value > 0 do
    with {:ok, _} <- CurrencyBrowser.currency_is_valid(currency_from) do
      AccountState.deposit(
        pid,
        Currency.convert(currency_from, AccountState.show(pid).currency, value)
      )
    end
  end

  def deposit(_, _, _),
    do:
      raise(ArgumentError,
        message: "The first arg must be a pid and de second arg must be a number"
      )

  @doc """
    Takes out the value of an account.

  ## Examples
    {_, pid} = FinancialSystem.create("Yashin Santos", "EUR", 220)
    FinancialSystem.withdraw(pid, 10)
  """
  @impl true
  def withdraw(pid, value) when is_pid(pid) and is_number(value) == value > 0 do
    with {:ok, _} <- FinHelper.funds(pid, value) do
      AccountState.withdraw(
        pid,
        Currency.amount_do(:store, value, AccountState.show(pid).currency)
      )
    end
  end

  def withdraw(_, _),
    do:
      raise(ArgumentError,
        message: "The first arg must be a pid and de second arg must be a number"
      )

  @doc """
   Transfer of values ​​between accounts.

  ## Examples
    {_, pid} = FinancialSystem.create("Yashin Santos", "EUR", 220)
    {_, pid2} = FinancialSystem.create("Antonio Marcos", "BRL", 100)
    FinancialSystem.transfer(15, pid, pid2)
  """
  @impl true
  def transfer(value, pid_from, pid_to)
      when is_pid(pid_from) and
             pid_from != pid_to and is_pid(pid_to) and is_number(value) == value > 0 do
    with {:ok, _} <- FinHelper.funds(pid_from, value),
         {:ok, _} <- FinHelper.transfer_have_account_from(pid_from, pid_to) do
      withdraw(pid_from, value)

      deposit(pid_to, AccountState.show(pid_from).currency, value)
    end
  end

  def transfer(_, _, _),
    do:
      raise(ArgumentError,
        message: "The second and third args must be a pid and de first arg must be a number"
      )

  @doc """
   Transfer of values ​​between multiple accounts.

  ## Examples
    {_, pid} = FinancialSystem.create("Yashin Santos", "EUR", 220)
    {_, pid2} = FinancialSystem.create("Antonio Marcos", "BRL", 100)
    {_, pid3} = FinancialSystem.create("Mateus Mathias", "BRL", 100)
    split_list = [%FinancialSystem.SplitDefinition{account: pid2, percent: 80}, %FinancialSystem.SplitDefinition{account: pid3, percent: 20}]
    FinancialSystem.split(pid, split_list, 100)
  """
  @impl true
  def split(pid_from, split_list, value)
      when is_pid(pid_from) and is_list(split_list) and is_number(value) == value > 0 do
    with {:ok, _} <- FinHelper.funds(pid_from, value),
         {:ok, _} <- FinHelper.percent_ok(split_list),
         {:ok, _} <- FinHelper.transfer_have_account_from(pid_from, split_list) do
      split_list
      |> FinHelper.unite_equal_account_split()
      |> Enum.map(fn %Split{account: pid_to, percent: percent} ->
        percent
        |> Kernel./(100)
        |> Kernel.*(value)
        |> transfer(pid_from, pid_to)
      end)
    end
  end

  def split(_, _, _),
    do:
      raise(ArgumentError,
        message:
          "The first arg must be a pid, the second must be a list with %SplitDefinition{} and the third must be a value."
      )
end
