defmodule FinancialSystem.AccountState do
  @moduledoc """
  This module is responsable for keep and managing the accounts state.
  """
  use GenServer
  alias FinancialSystem.Account, as: Account

  def start(state) do
    GenServer.start(__MODULE__, state)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(:get_data, _, state) do
    {:reply, state, state}
  end

  def handle_cast({:deposit, value}, account) do
    {:noreply, %Account{account | value: account.value + value}}
  end

  def handle_cast({:withdraw, value}, account) do
    {:noreply, %Account{account | value: account.value - value}}
  end

  @doc """
    Show the state.

  ## Examples
    {_, pid} = FinancialSystem.create("Yashin Santos", "EUR", 220)
    FinancialSystem.AccountState.show(pid)
  """
  @spec show(pid()) :: Account.t() | no_return()
  def show(account) when is_pid(account) do
    GenServer.call(account, :get_data)
  end

  @doc """
    Subtracts value in deposit operations.

  ## Examples
    {_, pid} = FinancialSystem.create("Yashin Santos", "EUR", 220)
    FinancialSystem.AccountState.withdraw(pid, 100)
  """
  @spec withdraw(pid(), number()) :: Account.t() | no_return()
  def withdraw(account, value) when is_pid(account) and is_number(value) do
    GenServer.cast(account, {:withdraw, value})
    show(account)
  end

  @doc """
    Sum value in deposit operations.

  ## Examples
    {_, pid} = FinancialSystem.create("Yashin Santos", "EUR", 220)
    FinancialSystem.AccountState.deposit(pid, 100)
  """
  @spec deposit(pid(), number()) :: Account.t() | no_return()
  def deposit(account, value) when is_pid(account) and is_number(value) do
    GenServer.cast(account, {:deposit, value})
    show(account)
  end
end
