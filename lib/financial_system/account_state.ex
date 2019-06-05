defmodule FinancialSystem.AccountOperations do
  @moduledoc """
  This module is responsable for keep and managing the accounts state.
  """
  import Ecto.Query, only: [from: 2]

  alias FinancialSystem.{Accounts.AccountsRepo, Repo}

  @doc """
    Register the account in system.

  ## Examples
    account_struct = %FinancialSystem.Account{ account_id: UUID.uuid4(), name: "Oliver Tsubasa", currency: "BRL", value: 100 }

    FinancialSystem.AccountOperations.register_account(account_struct)
  """
  def register_account(%AccountsRepo{
        name: name,
        currency: currency,
        value: value
      }) do
    %AccountsRepo{name: name, currency: currency, value: value}
    |> AccountsRepo.changeset()
    |> Repo.insert()
    |> do_register_account()
  end

  def register_account(_), do: {:error, :invalid_arguments_type}

  defp do_register_account({:ok, result}), do: {:ok, result}

  @doc """
    Delete an account from system.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.AccountOperations.delete_account(account.id)
  """
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

    FinancialSystem.AccountOperations.show(account.id)
  """
  @spec show(String.t()) :: AccountsRepo.t() | no_return() | atom()
  def show(account) when is_binary(account) do
    AccountsRepo
    |> Repo.get(account)
  end

  @doc """
    Checks if the account exists.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.AccountOperations.account_exist(account.id)
  """
  @spec account_exist(String.t()) :: {:ok, AccountsRepo.t()} | {:error, atom()}
  def account_exist(account_id) when is_binary(account_id) do
    AccountsRepo
    |> Repo.get(account_id)
    |> do_account_exist()
  rescue
    Ecto.Query.CastError -> {:error, :invalid_account_id_type}
  end

  defp do_account_exist(nil), do: {:error, :account_dont_exist}

  defp do_account_exist(account), do: {:ok, account}

  @doc """
    Subtracts value in deposit operations.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.AccountOperations.withdraw(account.id, 100)
  """
  @spec withdraw(AccountsRepo.t(), pos_integer()) :: AccountsRepo.t() | no_return()
  def withdraw(%AccountsRepo{id: id, name: _, currency: _, value: _} = account, value)
      when is_integer(value) and value > 0 do
    from(u in "accounts",
      where: u.id == type(^id, :binary_id),
      select: u.value - type(^value, :integer)
    )
    |> FinancialSystem.Repo.all()
    |> List.first()
    |> make_operation(account)
  end

  @doc """
    Sum value in deposit operations.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.AccountOperations.deposit(account.id, 100)
  """
  @spec deposit(AccountsRepo.t(), integer()) :: AccountsRepo.t() | no_return()
  def deposit(%AccountsRepo{id: id, name: _, currency: _, value: _} = account, value)
      when is_integer(value) and value > 0 do
    from(u in "accounts",
      where: u.id == type(^id, :binary_id),
      select: u.value + type(^value, :integer)
    )
    |> FinancialSystem.Repo.all()
    |> List.first()
    |> make_operation(account)
  end

  defp make_operation(value, account) do
    account
    |> AccountsRepo.changeset(%{value: value})
    |> Repo.update()

    show(account.id)
  end
end
