defmodule FinancialSystem.AccountState do
  @moduledoc """
  This module is responsable for keep and managing the accounts state.
  """
  use GenServer
  alias FinancialSystem.Account, as: Account

  def start_link(state \\ %{}) do
    GenServer.start(__MODULE__, state, name: :register_account)
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
    operation = fn a, b -> a + b end

    {:noreply, make_operation(system_accounts, account, value, operation)}
  end

  def handle_cast({:withdraw, account, value}, system_accounts) do
    operation = fn a, b -> a - b end

    {:noreply, make_operation(system_accounts, account, value, operation)}
  end

  defp make_operation(system_accounts, account, value, operation) do
    Map.update!(system_accounts, account, fn acc ->
      %{acc | value: operation.(acc.value, value)}
    end)
  end

  @doc """
    Register the account in system.

  ## Examples
    account_struct = %FinancialSystem.Account{ account_id: UUID.uuid4(), name: "Oliver Tsubasa", currency: "BRL", value: 100 }

    FinancialSystem.AccountState.register_account(account_struct)
  """
  @spec register_account(Account.t() | any()) :: {:ok, Account.t()} | {:error, String.t()}
  def register_account(%Account{account_id: _, name: _, currency: _, value: _} = params) do
    {:ok, GenServer.call(:register_account, {:create_account, params})[params.account_id]}
  end

  def register_account(_), do: {:error, "The arg must be a %Account struct."}

  @doc """
    Show the state.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.AccountState.show(account.account_id)
  """
  @spec show(String.t()) :: Account.t() | no_return() | atom()
  def show(account) when is_binary(account) do
    GenServer.call(:register_account, :get_data)[account]
  end

  @doc """
    Checks if the account exists.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.AccountState.account_exist(account.account_id)
  """
  @spec account_exist(String.t()) :: {:ok, boolean()} | {:error, String.t()}
  def account_exist(account) do
    do_account_exist(
      GenServer.call(:register_account, {:account_exist, account}),
      account
    )
  end

  defp do_account_exist(true, _), do: {:ok, true}

  defp do_account_exist(false, account), do: {:error, "The account #{account} dont exist"}

  @doc """
    Subtracts value in deposit operations.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.AccountState.withdraw(account.account_id, 100)
  """
  @spec withdraw(String.t(), integer()) :: Account.t() | no_return()
  def withdraw(account, value) when is_binary(account) and is_integer(value) and value > 0 do
    GenServer.cast(:register_account, {:withdraw, account, value})
    show(account)
  end

  @doc """
    Sum value in deposit operations.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.AccountState.deposit(account.account_id, 100)
  """
  @spec deposit(String.t(), integer()) :: Account.t() | no_return()
  def deposit(account, value) when is_binary(account) and is_integer(value) and value > 0 do
    GenServer.cast(:register_account, {:deposit, account, value})
    show(account)
  end
end
