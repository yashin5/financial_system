defmodule FinancialSystem.Account do
  @moduledoc """
  This module is responsable for detemrinate the struct of accounts.
  """

  alias FinancialSystem.{
    AccountOperations,
    Accounts.Account,
    Accounts.AccountRepository,
    Currency
  }

  defp currency_finder, do: Application.get_env(:financial_system, :currency_finder)

  @doc """
    Create user accounts

  ## Examples
    FinancialSystem.create("Yashin Santos",  "EUR", "220")
  """
  @callback create(String.t() | any(), String.t() | any(), String.t() | any()) ::
              {:ok, Account.t()} | {:error, atom()}

  def create(name, currency, value)
      when is_binary(name) and is_binary(currency) and is_binary(value) do
    with {:ok, currency_upcase} <- currency_finder().currency_is_valid(currency),
         {:ok, value_in_integer} <- Currency.amount_do(:store, value, currency_upcase),
         true <- byte_size(name) > 0,
         {:ok, account_created} <-
           name
           |> new(currency_upcase, value_in_integer)
           |> AccountRepository.register_account() do
      {:ok, account_created}
    end
  end

  def create(name, currency, value)
      when not is_binary(name) and is_binary(currency) and is_binary(value) do
    {:error, :invalid_name}
  end

  def create(name, currency, value)
      when is_binary(name) and not is_binary(currency) and is_binary(value) do
    {:error, :invalid_currency_type}
  end

  def create(name, currency, value)
      when is_binary(name) and is_binary(currency) and not is_binary(value) do
    {:error, :invalid_value_type}
  end

  defp new(name, currency, value) do
    %Account{
      name: name,
      currency: currency,
      value: value
    }
  end

  @doc """
    Delete a existent account.

  ## Examples
    {:ok, account} = FinancialSystem.create("Yashin Santos",  "EUR", "220")

    FinancialSystem.Account.delete(account.id)
  """
  @callback delete(String.t()) :: {:ok | :error, atom()}
  def delete(account_id) when is_binary(account_id) do
    with {:ok, account} <- AccountOperations.find_account(account_id) do
      AccountRepository.delete_account(account)
    end
  end

  def delete(_), do: {:error, :invalid_account_id_type}
end
