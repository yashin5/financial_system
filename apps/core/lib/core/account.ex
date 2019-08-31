defmodule FinancialSystem.Core.Account do
  @moduledoc """
  This module is responsable for detemrinate the struct of accounts.
  """

  alias FinancialSystem.Core.{
    Accounts.Account,
    Accounts.AccountRepository,
    Currency
  }

  alias FinancialSystem.Core.Users.UserRepository

  defp currency_finder, do: Application.get_env(:core, :currency_finder)

  @doc """
    Create user accounts

  ## Examples
    FinancialSystem.Core.create(%{
        "name" => "Yashin Santos",
        "currency" => "EUR",
        "value" => "220",
        "email" => "xx@xx.com",
        "password" => "B@xopn123"
      })
  """
  @callback create(
              String.t() | any(),
              String.t() | any(),
              String.t() | any(),
              String.t() | any(),
              String.t() | any()
            ) ::
              {:ok, Account.t()} | {:error, atom()}

  def create(%{
        "name" => name,
        "currency" => currency,
        "value" => value,
        "email" => email,
        "password" => password
      })
      when is_binary(name) and is_binary(currency) and is_binary(value) do
    with {:ok, currency_upcase} <- currency_finder().currency_is_valid(currency),
         {:ok, value_in_integer} <- Currency.amount_do(:store, value, currency_upcase),
         {:ok, user_created} <- UserRepository.new_user(name, email, password),
         {:ok, account_created} <-
           currency_upcase
           |> new(value_in_integer)
           |> AccountRepository.register_account(user_created) do
      {:ok, account_created}
    end
  end

  def create(%{
        "name" => name,
        "currency" => currency,
        "value" => value,
        "email" => _email,
        "password" => _password
      })
      when not is_binary(name) and is_binary(currency) and is_binary(value) do
    {:error, :invalid_name}
  end

  def create(%{
        "name" => name,
        "currency" => currency,
        "value" => value,
        "email" => _email,
        "password" => _password
      })
      when is_binary(name) and not is_binary(currency) and is_binary(value) do
    {:error, :invalid_currency_type}
  end

  def create(%{
        "name" => name,
        "currency" => currency,
        "value" => value,
        "email" => _email,
        "password" => _password
      })
      when is_binary(name) and is_binary(currency) and not is_binary(value) do
    {:error, :invalid_value_type}
  end

  defp new(currency, value) do
    %Account{
      active: true,
      currency: currency,
      value: value
    }
  end

  @doc """
    Delete a existent account.

  ## Examples
    {:ok, account} = FinancialSystem.Core.create(%{
        "name" => "Yashin Santos",
        "currency" => "EUR",
        "value" => "220",
        "email" => "xx@xx.com",
        "password" => "B@xopn123"
      })

    FinancialSystem.Core.Account.delete(account.id)
  """
  @callback delete(String.t()) :: {:ok | :error, atom()}
  def delete(%{
        "id" => account_id
      })
      when is_binary(account_id) do
    with {:ok, account} <- AccountRepository.find_account(account_id) do
      AccountRepository.delete_account(account)
    end
  end

  def delete(_), do: {:error, :invalid_account_id_type}
end
