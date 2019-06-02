defmodule FinancialSystem do
  @moduledoc """
  This module is responsable to implement the financial operations.
  """

  alias FinancialSystem.{Account, Financial, FinancialOperations}

  @behaviour FinancialSystem.Financial

  defdelegate create(name, currency, value), to: Account

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
end
