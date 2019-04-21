defmodule FinancialSystem.AccountState do
  @moduledoc """
  This module is responsable for keep and managing the accounts state.
  """
  use GenServer
  alias FinancialSystem.Account, as: Account

  @spec start(any()) :: {:ok, pid()}
  def start(state) do
    GenServer.start(__MODULE__, state)
  end

  @spec init(any()) :: {:ok, any()}
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
    {:noreply, %Account{account | value: account.value + value}}
  end

  @doc """
    Subtracts value in deposit operations.

  ## Examples
    {_, pid} = FinancialSystem.create("Yashin Santos", "EUR", 220)
    GenServer.cast(pid, {:withdraw, 100})
  """
  def handle_cast({:withdraw, value}, account) do
    {:noreply, %Account{account | value: account.value - value}}
  end
end
