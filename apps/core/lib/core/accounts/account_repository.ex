defmodule FinancialSystem.Core.Accounts.AccountRepository do
  @moduledoc false

  alias FinancialSystem.Core.{Accounts.Account, Repo}

  @doc """
    Register the account in system.

  ## Examples
    account_struct = %FinancialSystem.Core.Accounts.Account{name: "Oliver Tsubasa", currency: "BRL", value: 100 }

    FinancialSystem.Core.AccountRepository.register_account(account_struct)
  """
  def register_account(%Account{} = account) do
    account
    |> Account.changeset()
    |> Repo.insert()
    |> do_register_account()
  end

  def register_account(_), do: {:error, :invalid_arguments_type}

  defp do_register_account({:ok, result}), do: {:ok, result}

  @doc """
    Delete an account from system.

  ## Examples
    {_, account} = FinancialSystem.Core.create("Yashin Santos", "EUR", "220")

    FinancialSystem.Core.AccountRepository.delete_account(account)
  """
  def delete_account(%Account{} = account) do
    account
    |> Account.changeset(%{active: false})
    |> Repo.update()
    |> do_delete_account()
  end

  def delete_account(_), do: {:error, :invalid_account_type}

  defp do_delete_account({:ok, _}), do: {:ok, :account_deleted}

  @doc """
    Checks if the account exists.

  ## Examples
    {_, account} = FinancialSystem.Core.create("Yashin Santos", "EUR", "220")

    FinancialSystem.Core.AccountRepository.find_account(account.id)
  """
  @spec find_account(String.t()) :: {:ok, Account.t()} | {:error, atom()}
  def find_account(account_id) when is_binary(account_id) do
    Account
    |> Repo.get(account_id)
    |> do_find_account()
  rescue
    Ecto.Query.CastError -> {:error, :invalid_account_id_type}
  end

  defp do_find_account(%Account{active: true} = account), do: {:ok, account}

  defp do_find_account(_), do: {:error, :account_dont_exist}
end
