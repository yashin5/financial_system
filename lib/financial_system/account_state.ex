defmodule FinancialSystem.AccountState do
  @moduledoc """
  This module is responsable for keep and managing the accounts state.
  """
  use GenServer
  alias FinancialSystem.Account, as: Account

  def start(state, process_name) do
    GenServer.start(__MODULE__, state, name: process_name)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(:get_data, _, state) do
    {:reply, state, state}
  end

  def handle_call({:create_account, state}, _, system_accounts) do
    {:reply, Map.put(system_accounts, state.account_id, state),
     Map.put(system_accounts, state.account_id, state)}
  end

  def handle_call({:account_exist, account}, _, system_accounts) do
    {:reply, Map.has_key?(system_accounts, account), system_accounts}
  end

  def handle_cast({:deposit, account, value}, system_accounts) do
    operation = fn a, b -> Kernel.+(a, b) end

    {:noreply, make_operation(system_accounts, account, value, operation)}
  end

  def handle_cast({:withdraw, account, value}, system_accounts) do
    operation = fn a, b -> Kernel.-(a, b) end

    {:noreply, make_operation(system_accounts, account, value, operation)}
  end

  defp make_operation(system_accounts, account, value, operation) do
    Map.update!(system_accounts, account, fn acc ->
      %{acc | value: operation.(acc.value, value)}
    end)
  end

  def register_account(state) do
    GenServer.call(:register, {:create_account, state})[state.account_id]
  end

  @doc """
    Show the state.

  ## Examples
    {_, pid} = FinancialSystem.create("Yashin Santos", "EUR", 220)

    FinancialSystem.AccountState.show(pid)
  """
  @spec show(pid()) :: Account.t() | no_return()
  def show(account) when is_number(account) do
    GenServer.call(:register, :get_data)[account]
  end

  def account_exist(:check, account) do
    do_account_exist(:check, GenServer.call(:register, {:account_exist, account}), account)
  end

  def account_exist(:create, account) do
    with {:ok, account_id} <- do_account_exist(:create, GenServer.call(:register, {:account_exist, account}), account)do
      {:ok, account_id}
    end
  end

  defp do_account_exist(:create, true, account_id) do
       account_exist(:create, account_id + 1)
  end

  defp do_account_exist(:create, false, account), do: {:ok, account}

  defp do_account_exist(:check, true, account), do: {:ok, account}

  defp do_account_exist(:check, false, account), do: {:error, "The account #{account} dont exist"}

  @doc """
    Subtracts value in deposit operations.

  ## Examples
    {_, pid} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.AccountState.withdraw(pid, 100)
  """
  @spec withdraw(pid(), number()) :: Account.t() | no_return()
  def withdraw(account, value) when is_number(account) and is_number(value) and value > 0 do
    GenServer.cast(:register, {:withdraw, account, value})
    show(account)
  end

  @doc """
    Sum value in deposit operations.

  ## Examples
    {_, pid} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.AccountState.deposit(pid, 100)
  """
  @spec deposit(pid(), number()) :: Account.t() | no_return()
  def deposit(account, value) when is_number(account) and is_number(value) and value > 0 do
    GenServer.cast(:register, {:deposit, account, value})
    show(account)
  end
end
