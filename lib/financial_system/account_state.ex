defmodule FinancialSystem.AccountState do
  @moduledoc """
  This module is responsable for keep and managing the accounts state.
  """

  alias FinancialSystem.Account, as: Account

  @doc """
    Register the account in system.

  ## Examples
    account_struct = %FinancialSystem.Account{ account_id: UUID.uuid4(), name: "Oliver Tsubasa", currency: "BRL", value: 100 }

    FinancialSystem.AccountState.register_account(account_struct)
  """
  def register_account(%Account{
        name: name,
        currency: currency,
        value: value,
        account_id: account_id
      }) do
    %AccountsRepo{name: name, currency: currency, value: value, id: account_id}
    |> AccountsRepo.changeset()
    |> Repo.insert()
    |> do_register_account()
  end

  defp do_register_account({:ok, result}), do: {:ok, result}

  defp do_register_account({:error, reasons}) do
    Ecto.Changeset.traverse_errors(reasons, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

  def delete_account(account_id) when is_binary(account_id) do
    AccountsRepo
    |> Repo.get(account_id)
    |> Repo.delete()
    |> do_delete_account()
  end

  def delete_account(_), do: {:error, :invalid_account_id_type}

  defp do_delete_account({:ok, _}), do: {:ok, :account_deleted}

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
  @spec register_account(Account.t() | any()) :: {:ok, Account.t()} | {:error, atom()}
  def register_account(%Account{account_id: _, name: _, currency: _, value: _} = params) do
    {:ok, GenServer.call(:register_account, {:create_account, params})[params.account_id]}
  end

  def register_account(_), do: {:error, :invalid_arguments_type}

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
  @spec account_exist(String.t()) :: {:ok, boolean()} | {:error, atom()}
  def account_exist(account) do
    do_account_exist(
      GenServer.call(:register_account, {:account_exist, account}),
      account
    )
  end

  defp do_account_exist(true, _), do: {:ok, true}

  defp do_account_exist(false, _), do: {:error, :account_dont_exist}

  @doc """
    Subtracts value in deposit operations.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.AccountState.withdraw(account.account_id, 100)
  """
  @spec withdraw(String.t(), pos_integer()) :: Account.t() | no_return()
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
