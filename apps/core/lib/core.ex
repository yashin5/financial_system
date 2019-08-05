defmodule FinancialSystem.Core do
  @moduledoc """
  This module is responsable to implement the financial operations.
  """

  alias FinancialSystem.Core.{Account, Financial, FinancialOperations}

  @behaviour FinancialSystem.Core.Account

  @behaviour FinancialSystem.Core.Financial

  @impl Account
  defdelegate create(name, currency, value, email, password), to: Account

  @impl Account
  defdelegate delete(account_id), to: Account

  @impl Financial
  defdelegate show(account), to: FinancialOperations

  @impl Financial
  defdelegate deposit(account, currency, value), to: FinancialOperations

  @impl Financial
  defdelegate withdraw(account, value), to: FinancialOperations

  @impl Financial
  defdelegate transfer(account_from, account_to, value), to: FinancialOperations

  @impl Financial
  defdelegate split(account_from, split_list, value), to: FinancialOperations

  @impl Financial
  defdelegate financial_statement(account_id), to: FinancialOperations
end
