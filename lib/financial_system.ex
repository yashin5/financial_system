defmodule FinancialSystem do
  @moduledoc """
  This module is responsable to implement the financial operations.
  """

  @behaviour FinancialSystem.Financial

  alias FinancialSystem.{Account, FinancialOperations}

  defdelegate create(name, currency, value), to: Account, as: :create

  @impl true
  defdelegate show(account), to: FinancialOperations, as: :show

  @impl true
  defdelegate deposit(account, currency, value), to: FinancialOperations, as: :deposit

  @impl true
  defdelegate withdraw(account, value), to: FinancialOperations, as: :withdraw

  @impl true
  defdelegate transfer(account_from, account_to, value), to: FinancialOperations, as: :transfer

  @impl true
  defdelegate split(account_from, split_list, value), to: FinancialOperations, as: :split
end
