defmodule FinancialSystem.Core do
  @moduledoc """
  This module is responsable to implement the financial operations.
  """

  alias FinancialSystem.Core.{
    Account,
    Contacts.ContactRepository,
    Financial,
    FinancialOperations,
    Users.UserRepository
  }

  @behaviour FinancialSystem.Core.Account

  @behaviour FinancialSystem.Core.Contacts.ContactRepository

  @behaviour FinancialSystem.Core.Financial

  @behaviour FinancialSystem.Core.Users.UserRepository

  @impl UserRepository
  defdelegate authenticate(params), to: UserRepository, as: :authenticate

  @impl Account
  defdelegate create(params), to: Account

  @impl Account
  defdelegate delete(param), to: Account

  @impl Financial
  defdelegate show(account), to: FinancialOperations

  @impl Financial
  defdelegate deposit(params), to: FinancialOperations

  @impl Financial
  defdelegate withdraw(params), to: FinancialOperations

  @impl Financial
  defdelegate transfer(params), to: FinancialOperations

  @impl Financial
  defdelegate split(params), to: FinancialOperations

  @impl Financial
  defdelegate financial_statement(param), to: FinancialOperations

  @impl ContactRepository
  defdelegate create_contact(params), to: ContactRepository

  @impl ContactRepository
  defdelegate get_all_contacts(params), to: ContactRepository

  defdelegate update_contact_nickname(params), to: ContactRepository
end
