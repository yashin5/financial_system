defmodule FinancialSystem do
  @moduledoc """
  This module is responsable to implement the financial operations.
  """

  @behaviour FinancialSystem.Financial

  alias FinancialSystem.{Account, FinancialOperations}

  defdelegate create(name, currency, value), to: Account, as: :create

  defdelegate show(account), to: FinancialOperations, as: :show

  defdelegate deposit(account, currency, value), to: FinancialOperations, as: :deposit

  defdelegate withdraw(account, value), to: FinancialOperations, as: :withdraw

  defdelegate transfer(account_from, account_to, value), to: FinancialOperations, as: :transfer

  defdelegate split(account_from, split_list, value), to: FinancialOperations, as: :split
end
