defmodule FinancialSystem.AccountState do
  @moduledoc """
  This module is responsable for keep and managing the accounts state.
  """

  alias FinancialSystem.{Account, Repo}
  alias FinancialSystem.Accounts.AccountsRepo

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

  @doc """
    Show the state.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.AccountState.show(account.id)
  """
  @spec show(String.t()) :: Account.t() | no_return() | atom()
  def show(account) when is_binary(account) do
    AccountsRepo
    |> Repo.get(account)
  end

  @doc """
    Checks if the account exists.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.AccountState.account_exist(account.id)
  """
  @spec account_exist(String.t()) :: {:ok, boolean()} | {:error, atom()}
  def account_exist(account_id) do
    AccountsRepo
    |> Repo.all()
    |> Enum.map(fn accounts -> accounts.id == account_id end)
    |> Enum.member?(true)
    |> do_account_exist()
  end

  defp do_account_exist(true), do: {:ok, true}

  defp do_account_exist(false), do: {:error, :account_dont_exist}

  @doc """
    Subtracts value in deposit operations.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.AccountState.withdraw(account.id, 100)
  """
  @spec withdraw(String.t(), pos_integer()) :: Account.t() | no_return()
  def withdraw(account, value) when is_binary(account) and is_integer(value) and value > 0 do
    operation = fn a, b -> a - b end

    make_operation(account, value, operation)
  end

  @doc """
    Sum value in deposit operations.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.AccountState.deposit(account.id, 100)
  """
  @spec deposit(String.t(), integer()) :: Account.t() | no_return()
  def deposit(account, value) when is_binary(account) and is_integer(value) and value > 0 do
    operation = fn a, b -> a + b end

    make_operation(account, value, operation)
  end

  defp make_operation(account, value, operation) do
    show(account)
    |> AccountsRepo.changeset(%{value: operation.(show(account).value, value)})
    |> Repo.update()

    show(account)
  end
end
