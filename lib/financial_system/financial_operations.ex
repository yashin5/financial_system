defmodule FinancialSystem.FinancialOperations do
  @moduledoc """
  This module is responsable to define the operations in this API
  """

  alias FinancialSystem.{AccountState, Currency, FinHelper}
  alias FinancialSystem.Currency.CurrencyImpl

  @behaviour FinancialSystem.Financial

  @doc """
    Show the value in account.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.show(account.account_id)
  """

  @impl true
  def show(account) when is_binary(account) do
    with {:ok, _} <- AccountState.account_exist(account) do
      Currency.amount_do(
        :show,
        AccountState.show(account).value,
        AccountState.show(account).currency
      )
    end
  end

  def show(_), do: raise(ArgumentError, message: "Please insert a valid account ID.")

  @doc """
    Deposit value in account.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.deposit(account.account_id, "BRL", "10")
  """
  @impl true
  def deposit(account, currency_from, value) when is_binary(account) and is_binary(value) do
    with {:ok, _} <- AccountState.account_exist(account),
         {:ok, _} <- CurrencyImpl.currency_is_valid(currency_from),
         {:ok, value_in_integer} <-
           Currency.convert(currency_from, AccountState.show(account).currency, value) do
      {:ok, AccountState.deposit(account, value_in_integer)}
    end
  end

  def deposit(_, _, _),
    do:
      {:error,
       "The first arg must be a account ID and de second arg must be a number in type string."}

  @doc """
    Takes out the value of an account.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

    FinancialSystem.withdraw(account.account_id, "10")
  """
  @impl true
  def withdraw(account, value) when is_binary(account) and is_binary(value) do
    with {:ok, _} <- AccountState.account_exist(account),
         {:ok, value_in_integer} <-
           Currency.amount_do(:store, value, AccountState.show(account).currency),
         {:ok, _} <- FinHelper.funds(account, value_in_integer) do
      {:ok,
       AccountState.withdraw(
         account,
         value_in_integer
       )}
    end
  end

  def withdraw(_, _),
    do:
      {:error,
       "The first arg must be a account ID and de second arg must be a number in type string."}

  @doc """
   Transfer of values ​​between accounts.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")
    {_, account2} = FinancialSystem.create("Antonio Marcos", "BRL", "100")

    FinancialSystem.transfer("15", account.account_id, account2.account_id)
  """
  @impl true
  def transfer(value, account_from, account_to)
      when is_binary(account_from) and is_binary(account_to) and is_binary(value) do
    with {:ok, _} <- FinHelper.transfer_have_account_from(account_from, account_to),
         {:ok, withdraw_result} <- withdraw(account_from, value),
         {:ok, _} <- deposit(account_to, AccountState.show(account_from).currency, value) do
      {:ok, withdraw_result}
    end
  end

  def transfer(_, _, _),
    do:
      {:error,
       "The first arg must be a number in type string and the second and third args must be a account ID."}

  @doc """
   Transfer of values ​​between multiple accounts.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "100")
    {_, account2} = FinancialSystem.create("Antonio Marcos", "BRL", "100")
    {_, account3} = FinancialSystem.create("Mateus Mathias", "BRL", "100")
    split_list = [%FinancialSystem.Split{account: account.account_id, percent: 50}, %FinancialSystem.Split{account: account3.account_id, percent: 50}]

    FinancialSystem.split(account2.account_id, split_list, "100")
  """
  @impl true
  def split(account_from, split_list, value)
      when is_binary(account_from) and is_list(split_list) and is_binary(value) do
    with {:ok, _} <- FinHelper.percent_ok(split_list),
         {:ok, _} <- FinHelper.transfer_have_account_from(account_from, split_list),
         {:ok, united_accounts} <- FinHelper.unite_equal_account_split(split_list),
         {:ok, value_in_integer} <-
           Currency.amount_do(:store, value, AccountState.show(account_from).currency),
         {:ok, _} <-
           FinHelper.funds(account_from, value_in_integer),
         {:ok, list_to_transfer} <-
           FinHelper.division_of_values_to_make_split_transfer(united_accounts, value) do
      Enum.each(list_to_transfer, fn data_transfer ->
        transfer(
          data_transfer.value_to_transfer,
          account_from,
          data_transfer.account_to_transfer
        )
      end)

      {:ok, AccountState.show(account_from)}
    end
  end

  def split(_, _, _),
    do:
      {:error,
       "The first arg must be a account ID, the second must be a list with %Split{} and the third must be a number in type string."}
end
