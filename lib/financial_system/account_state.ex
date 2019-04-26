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

  @doc """
    Sum value in deposit operations.

  ## Examples
    {_, pid} = FinancialSystem.create("Yashin Santos", "EUR", 220)
    GenServer.cast(pid, {:deposit, 100})
  """
  def handle_cast({:deposit, value}, account) do
    {:noreply, %Account{account | value: Decimal.add(account.value, value)}}
  end

  @doc """
    Subtracts value in deposit operations.

  ## Examples
    {_, pid} = FinancialSystem.create("Yashin Santos", "EUR", 220)
    GenServer.cast(pid, {:withdraw, 100})
  """
  def handle_cast({:withdraw, value}, account) do
    {:noreply, %Account{account | value: Decimal.sub(account.value, value)}}
  end

  @spec show(pid()) :: Account.t() | no_return()
  def show(account) when is_pid(account) do
    GenServer.call(account, :get_data)
  end

  @spec withdraw(pid(), number()) :: Account.t() | no_return()
  def withdraw(account, value) when is_pid(account) do
    GenServer.cast(account, {:withdraw, value})
    show(account)
  end

  @spec deposit(pid(), number()) :: Account.t() | no_return()
  def deposit(account, value) when is_pid(account) do
    GenServer.cast(account, {:deposit, value})
    show(account)
  end
end
