defmodule FinancialSystem.Accounts.AccountRepository do
  @moduledoc false

  alias FinancialSystem.{Accounts.Account, Repo}

  @doc """
    Register the account in system.

  ## Examples
    account_struct = %FinancialSystem.Accounts.Account{name: "Oliver Tsubasa", currency: "BRL", value: 100 }

    FinancialSystem.AccountRepository.register_account(account_struct)
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
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.AccountRepository.delete_account(account)
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
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.AccountRepository.find_account(account.id)
  """
  @spec find_account(String.t()) :: {:ok, Account.t()} | {:error, atom()}
  def find_account(account_id) when is_binary(account_id) do
    Account
    |> Repo.get(account_id)
    |> check_account_status()
    |> do_find_account()
  rescue
    Ecto.Query.CastError -> {:error, :invalid_account_id_type}
  end

  defp check_account_status(%Account{active: true} = account), do: {account.active, account}

  defp check_account_status(%Account{active: false}), do: nil

  defp check_account_status(_), do: nil

  defp do_find_account(nil), do: {:error, :account_dont_exist}

  defp do_find_account({true, account}), do: {:ok, account}
end
