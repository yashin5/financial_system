defmodule ApiWeb.OperationsView do
  @moduledoc false

  use ApiWeb, :view

  def render("deposit.json", %{deposit: deposit}) do
    %{
      account_id: deposit.id,
      new_balance: deposit.value
    }
  end

  def render("withdraw.json", %{withdraw: withdraw}) do
    %{
      account_id: withdraw.id,
      new_balance: withdraw.value
    }
  end

  def render("transfer.json", %{transfer: transfer}) do
    %{
      account_id: transfer.id,
      new_balance: transfer.value
    }
  end

  def render("split.json", %{split: split}) do
    %{
      account_id: split.id,
      new_balance: split.value
    }
  end

  def render("financial_statement.json", %{
        financial_statement: financial_statement,
        account_id: id
      }) do
    %{
      account_id: id,
      transactions: financial_statement
    }
  end

  def render("show.json", %{
        show: value_in_account
      }) do
    %{
      value_in_account: value_in_account
    }
  end

  def render("view_all_accounts.json", %{
        all_accounts: accounts
      }) do
    Enum.map(accounts, fn account ->
      %{
        contact_account_id: account.id,
        contact_user_id: account.user_id,
        contact_value: accounts.value,
        contact_currency: accounts.currency,
        contact_active?: accounts.active
      }
    end)
  end

  def render("create_contact.json", %{
        contact: new_contact
      }) do
    %{
      contact: new_contact.email,
      contact_nickname: new_contact.nickname,
      contact_account_id: new_contact.account_id
    }
  end

  def render("get_all_contacts.json", %{
        contacts: contacts
      }) do
    Enum.map(contacts, fn contact ->
      %{
        contact_account_id: contact.account_id,
        contact_email: contact.email,
        contact_nickname: contact.nickname
      }
    end)
  end

  def render("update_contact_nickname.json", %{
        contact: contact_actualized
      }) do
    %{
      contact: contact_actualized.email,
      contact_nickname: contact_actualized.nickname,
      contact_account_id: contact_actualized.account_id
    }
  end
end
