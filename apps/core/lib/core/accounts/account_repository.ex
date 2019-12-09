defmodule FinancialSystem.Core.Accounts.AccountRepository do
  @moduledoc false

  alias FinancialSystem.Core.{Accounts.Account, Repo, Users.User}

  @doc """
  Register the account in system.

  ## Examples
      account_struct = %FinancialSystem.Core.Accounts.Account{active: true, currency: "BRL", value: 100 }

      FinancialSystem.Core.AccountRepository.register_account(account_struct)
  """
  def register_account(%Account{} = account, %User{} = user) do
    query = Ecto.build_assoc(user, :account, account)

    query
    |> Account.changeset()
    |> Repo.insert()
    |> do_register_account()
  end

  def register_account(_), do: {:error, :invalid_arguments_type}

  defp do_register_account({:ok, result}), do: {:ok, result}

  @doc """
  Delete an account from system.

  ## Examples
      {_, account} = FinancialSystem.Core.create(
        %{
          "name" => "Yashin Santos",
          "currency" => "EUR",
          "value" => "220",
          "email" => "xx@xx.com",
          "password" => "B@xopn123"
        })

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
      {_, account} = FinancialSystem.Core.create(%{

          "name" => "Yashin Santos",
          "currency" => "EUR",
          "value" => "220",
          "email" => "xx@xx.com",
          "password" => "B@xopn123"
        })

      FinancialSystem.Core.AccountRepository.find_account(:accountid, account.id)
  """
  @spec find_account(atom(), String.t()) :: {:ok, Account.t()} | {:error, atom()}
  def find_account(:accountid, account_id) when is_binary(account_id) do
    Account
    |> Repo.get(account_id)
    |> do_find_account()
  rescue
    Ecto.Query.CastError -> {:error, :invalid_account_id_type}
  end

  def find_account(:userid, user_id) when is_binary(user_id) do
    Account
    |> Repo.get_by(user_id: user_id)
    |> do_find_account()
  rescue
    Ecto.Query.CastError -> {:error, :invalid_account_id_type}
  end

  def find_account(:accountid, account_id) when not is_binary(account_id) do
    {:error, :invalid_account_id_type}
  end

  def find_account(:userid, user_id) when not is_binary(user_id) do
    {:error, :invalid_user_id_type}
  end

  defp do_find_account(%Account{active: true} = account), do: {:ok, account}

  defp do_find_account(_), do: {:error, :account_dont_exist}

  @callback view_all_accounts() :: list(Account.t())
  def view_all_accounts do
    Account |> Repo.all()
  end
end
