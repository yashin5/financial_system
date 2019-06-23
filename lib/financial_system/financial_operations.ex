defmodule FinancialSystem.FinancialOperations do
  @moduledoc """
  This module is responsable to define the operations in this API
  """

  alias FinancialSystem.{AccountOperations, Currency, FinHelper}

  @behaviour FinancialSystem.Financial

  defp currency_finder, do: Application.get_env(:financial_system, :currency_finder)

  @doc """
    Show the value in account.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.show(account.id)
  """
  @impl true
  def show(account_id) when is_binary(account_id) do
    with {:ok, account} <- AccountOperations.account_exist(account_id) do
      Currency.amount_do(
        :show,
        account.value,
        account.currency
      )
    end
  end

  def show(account_id) when not is_binary(account_id), do: {:error, :invalid_account_id_type}

  @doc """
    Deposit value in account.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.deposit(account.id, "BRL", "10")
  """
  @impl true
  def deposit(account_id, currency_from, value) when is_binary(account_id) and is_binary(value) do
    sum_value(account_id, currency_from, value, "deposit")
  end

  def deposit(account_id, currency_from, value)
      when not is_binary(account_id) and is_binary(currency_from) and is_binary(value) do
    {:error, :invalid_account_id_type}
  end

  def deposit(account_id, currency_from, value)
      when is_binary(account_id) and is_binary(currency_from) and not is_binary(value) do
    {:error, :invalid_value_type}
  end

  def deposit(account_id, currency_from, value)
      when is_binary(account_id) and not is_binary(currency_from) and is_binary(value) do
    {:error, :invalid_currency_type}
  end

  def deposit(_, _, _), do: {:error, :invalid_arguments_type}

  defp sum_value(account_id, currency_from, value, operation)
       when is_binary(operation) and operation in ["deposit", "transfer <"] and
              is_binary(account_id) and is_binary(value) do
    with {:ok, account} <- AccountOperations.account_exist(account_id),
         {:ok, _} <- currency_finder().currency_is_valid(currency_from),
         {:ok, value_in_integer} <-
           Currency.convert(currency_from, account.currency, value) do
      {:ok, AccountOperations.sum_value_in_balance(account, value_in_integer, operation)}
    end
  end

  @doc """
    Takes out the value of an account.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.withdraw(account.id, "10")
  """
  @impl true
  def withdraw(account_id, value) when is_binary(account_id) and is_binary(value) do
    subtract_value(account_id, value, "withdraw")
  end

  def withdraw(account, value) when not is_binary(account) and is_binary(value) do
    {:error, :invalid_account_id_type}
  end

  def withdraw(account, value) when is_binary(account) and not is_binary(value) do
    {:error, :invalid_value_type}
  end

  def withdraw(_, _), do: {:error, :invalid_arguments_type}

  defp subtract_value(account_id, value, operation)
       when is_binary(account_id) and is_binary(operation) and
              operation in ["withdraw", "transfer >"] and is_binary(value) do
    with {:ok, account} <- AccountOperations.account_exist(account_id),
         {:ok, value_in_integer} <-
           Currency.amount_do(:store, value, account.currency),
         {:ok, _} <- FinHelper.funds(account, value_in_integer) do
      {:ok,
       AccountOperations.subtract_value_in_balance(
         account,
         value_in_integer,
         operation
       )}
    end
  end

  @doc """
   Transfer of values ​​between accounts.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")
    {_, account2} = FinancialSystem.create("Antonio Marcos", "BRL", "100")

    FinancialSystem.transfer("15", account.id, account2.id)
  """
  @impl true
  def transfer(value, account_from, account_to)
      when is_binary(account_from) and is_binary(account_to) and is_binary(value) do
    with {:ok, account_from_valided} <- AccountOperations.account_exist(account_from),
         {:ok, _} <- FinHelper.transfer_have_account_from(account_from, account_to),
         {:ok, withdraw_result} <- subtract_value(account_from, value, "transfer >"),
         {:ok, _} <-
           sum_value(account_to, account_from_valided.currency, value, "transfer <") do
      {:ok, withdraw_result}
    end
  end

  def transfer(value, account_from, account_to)
      when (not is_binary(account_from) and is_binary(account_to)) or is_binary(value) do
    {:error, :invalid_account_id_type}
  end

  def transfer(value, account_from, account_to)
      when is_binary(account_from) and is_binary(account_to) and not is_binary(value) do
    {:error, :invalid_value_type}
  end

  def transfer(_, _, _), do: {:error, :invalid_arguments_type}

  @doc """
   Transfer of values ​​between multiple accounts.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "100")
    {_, account2} = FinancialSystem.create("Antonio Marcos", "BRL", "100")
    {_, account3} = FinancialSystem.create("Mateus Mathias", "BRL", "100")
    split_list = [%FinancialSystem.Split{account: account.id, percent: 50}, %FinancialSystem.Split{account: account3.id, percent: 50}]

    FinancialSystem.split(account2.id, split_list, "100")
  """
  @impl true
  def split(account_from, split_list, value)
      when is_binary(account_from) and is_list(split_list) and is_binary(value) do
    with {:ok, account} <- AccountOperations.account_exist(account_from),
         {:ok, _} <- FinHelper.percent_ok(split_list),
         {:ok, _} <- FinHelper.transfer_have_account_from(account_from, split_list),
         {:ok, united_accounts} <- FinHelper.unite_equal_account_split(split_list),
         {:ok, value_in_integer} <-
           Currency.amount_do(:store, value, account.currency),
         {:ok, _} <-
           FinHelper.funds(account, value_in_integer),
         {:ok, list_to_transfer} <-
           FinHelper.division_of_values_to_make_split_transfer(united_accounts, value) do
      Enum.each(list_to_transfer, fn data_transfer ->
        transfer(
          data_transfer.value_to_transfer,
          account_from,
          data_transfer.account_to_transfer
        )
      end)

      {_, account_from_state} = AccountOperations.account_exist(account_from)

      {:ok, account_from_state}
    end
  end

  def split(account_from, split_list, value)
      when not is_binary(account_from) and is_list(split_list) and is_binary(value) do
    {:error, :invalid_account_id_type}
  end

  def split(account_from, split_list, value)
      when is_binary(account_from) and not is_list(split_list) and is_binary(value) do
    {:error, :invalid_split_list_type}
  end

  def split(account_from, split_list, value)
      when is_binary(account_from) and is_list(split_list) and not is_binary(value) do
    {:error, :invalid_value_type}
  end

  def split(_, _, _) do
    {:error, :invalid_arguments_type}
  end

  @doc """
    Show the financial statement from account.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.withdraw(account.id, "1")

    FinancialSystem.financial_statement(account.id)
  """
  @impl true
  def financial_statement(account_id) when is_binary(account_id) do
    with {:ok, _} <- AccountOperations.account_exist(account_id) do
      {:ok, AccountOperations.show_financial_statement(account_id)}
    end
  end

  def financial_statement(_), do: {:error, :invalid_account_id_type}
end
