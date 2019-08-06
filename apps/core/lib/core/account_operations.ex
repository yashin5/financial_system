defmodule FinancialSystem.Core.AccountOperations do
  @moduledoc """
  This module is responsable for keep and managing the accounts state.
  """
  import Ecto.Query, only: [from: 2]

  alias FinancialSystem.Core.{
    Accounts.Account,
    Accounts.AccountRepository,
    Accounts.Transaction,
    Repo
  }

  @doc """
    Subtracts value in  operations.

  ## Examples
    {_, account} = FinancialSystem.Core.create("Yashin Santos", "EUR", "220")

    FinancialSystem.Core.AccountOperations.subtract_value_in_balance(account, 100, "withdraw")
  """
  @spec subtract_value_in_balance(Account.t(), pos_integer(), String.t()) ::
          Account.t() | no_return()
  def subtract_value_in_balance(%Account{id: id} = account, value, operation)
      when is_integer(value) and value > 0 do
    save_transaction(account, value, operation)

    id
    |> calculate_balance(value * -1)
    |> make_operation(account)
  end

  @doc """
    Sum value in operations.

  ## Examples
    {_, account} = FinancialSystem.Core.create("Yashin Santos", "EUR", "220")

    FinancialSystem.Core.AccountOperations.sum_value_in_balance(account, 100, "deposit")
  """
  @spec sum_value_in_balance(Account.t(), integer(), String.t()) :: Account.t() | no_return()
  def sum_value_in_balance(%Account{id: id} = account, value, operation)
      when is_integer(value) and value > 0 do
    save_transaction(account, value, operation)

    id
    |> calculate_balance(value)
    |> make_operation(account)
  end

  defp make_operation(value, account) do
    account
    |> Account.changeset(%{value: value})
    |> Repo.update()

    {_, account_actual_state} = AccountRepository.find_account(account.id)

    account_actual_state
  end

  defp save_transaction(account, value, operation) do
    query = Ecto.build_assoc(account, :transactions, %{value: value, operation: operation})

    query
    |> Transaction.changeset()
    |> Repo.insert()
  end

  defp calculate_balance(account_id, value) do
    query =
      from(u in Account,
        where: u.id == type(^account_id, :binary_id),
        select: u.value + type(^value, :integer),
        limit: 1
      )

    Repo.one(query)
  end

  @doc """
    Show the transactions from account.

  ## Examples
    {_, account} = FinancialSystem.Core.create("Yashin Santos", "EUR", "220")

    FinancialSystem.Core.deposit(account.id, "brl", "1")

    FinancialSystem.Core.AccountOperations.show_financial_statement(account.id)
  """
  @spec show_financial_statement(String.t()) :: list(Transaction.t())
  def show_financial_statement(id, order \\ :desc) when is_binary(id) do
    query =
      from(u in "transactions",
        where: u.account_id == type(^id, :binary_id),
        select: [:operation, :value, :inserted_at],
        order_by: [{^order, :inserted_at}]
      )

    Repo.all(query)
  end
end
