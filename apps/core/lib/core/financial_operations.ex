defmodule FinancialSystem.Core.FinancialOperations do
  @moduledoc """
  This module is responsable to define the operations in this API
  """

  alias FinancialSystem.Core.AccountOperations
  alias FinancialSystem.Core.Accounts.AccountRepository
  alias FinancialSystem.Core.Currency
  alias FinancialSystem.Core.FinHelper
  alias FinancialSystem.Core.Helpers

  @behaviour FinancialSystem.Core.Financial

  defp currency_finder, do: Application.get_env(:core, :currency_finder)

  @doc """
  Shows current formatted balance.

  ## Examples
      {_, account} = FinancialSystem.Core.create(%{
          "name" => "Yashin Santos",
          "currency" => "EUR",
          "value" => "220",
          "email" => "xx@xx.com",
          "password" => "B@xopn123"
        })

      FinancialSystem.Core.FinancialOperations.show(%{"account_id" => account.id})
  """
  @impl true
  def show(%{"account_id" => account_id}) when is_binary(account_id) do
    with {:ok, account} <- AccountRepository.find_account(:accountid, account_id) do
      %{value: value_formated} = format_value(account)

      {:ok, value_formated}
    end
  end

  def show(%{"account_id" => account_id}) when not is_binary(account_id),
    do: {:error, :invalid_account_id_type}

  def show(%{"email" => email}) when is_binary(email) do
    with {:ok, account} <- Helpers.get_account_or_user(:account, :email, %{"email" => email}) do
      show(%{"account_id" => account.id})
    end
  end

  @doc """
  Deposit value in account.

  ## Examples
      {_, account} = FinancialSystem.Core.create(%{
          "name" => "Yashin Santos",
          "currency" => "EUR",
          "value" => "220",
          "email" => "xqqqx@xx.com",
          "password" => "B@xopn123"
        })

      FinancialSystem.Core.FinancialOperations.deposit(%{
          "account_id" => account.id,
          "currency" => "BRL",
          "value" => "10"
        })
  """
  @impl true
  def deposit(%{
        "account_id" => account_id,
        "currency" => currency_from,
        "value" => value
      })
      when is_binary(account_id) and is_binary(value) and is_binary(currency_from) do
    sum_value(account_id, currency_from, value, "deposit")
  end

  def deposit(%{
        "account_id" => account_id,
        "currency" => currency_from,
        "value" => value
      })
      when not is_binary(account_id) and is_binary(currency_from) and is_binary(value) do
    {:error, :invalid_account_id_type}
  end

  def deposit(%{
        "account_id" => account_id,
        "currency" => currency_from,
        "value" => value
      })
      when is_binary(account_id) and is_binary(currency_from) and not is_binary(value) do
    {:error, :invalid_value_type}
  end

  def deposit(%{
        "account_id" => account_id,
        "currency" => currency_from,
        "value" => value
      })
      when is_binary(account_id) and not is_binary(currency_from) and is_binary(value) do
    {:error, :invalid_currency_type}
  end

  def deposit(_), do: {:error, :invalid_arguments_type}

  @doc """
  Takes out the value of an account.

  ## Examples
      {_, account} = FinancialSystem.Core.create(%{
          "name" => "Yashin Santos",
          "currency" => "EUR",
          "value" => "220",
          "email" => "xx@xx.com",
          "password" => "B@xopn123"
        })

      FinancialSystem.Core.FinancialOperations.withdraw(%{
          "account_id" => account.id,
          "value" => "10"
      })
  """
  @impl true
  def withdraw(%{
        "account_id" => account_id,
        "value" => value
      })
      when is_binary(account_id) and is_binary(value) do
    subtract_value(account_id, value, "withdraw")
  end

  def withdraw(%{
        "account_id" => account_id,
        "value" => value
      })
      when not is_binary(account_id) and is_binary(value) do
    {:error, :invalid_account_id_type}
  end

  def withdraw(%{
        "account_id" => account_id,
        "value" => value
      })
      when is_binary(account_id) and not is_binary(value) do
    {:error, :invalid_value_type}
  end

  def withdraw(_), do: {:error, :invalid_arguments_type}

  @doc """
  Transfer of values ​​between accounts.

  ## Examples
      {_, account} = FinancialSystem.Core.create(%{
          "name" => "Yashin Santos",
          "currency" => "EUR",
          "value" => "220",
          "email" => "xqqx@xx.com",
          "password" => "B@xopn123"
        })
      {_, account2} = FinancialSystem.Core.create(%{
          "name" => "Yashin Santos",
          "currency" => "BRL",
          "value" => "100",
          "email" => "xsx@xx.com",
          "password" => "B@xopn123"
        })

      FinancialSystem.Core.FinancialOperations.transfer(%{
          "value" => "15",
          "account_id" => account.id,
          "account_to" => account2.id
        })
  """
  @impl true
  def transfer(%{
        "value" => value,
        "account_id" => account_from,
        "account_to" => account_to
      })
      when is_binary(account_from) and is_binary(account_to) and is_binary(value) do
    with {:ok, account_from_valided} <- AccountRepository.find_account(:accountid, account_from),
         {:ok, _} <- FinHelper.transfer_have_account_from(account_from, account_to),
         {:ok, _} <-
           verify_value_after_convertion(value, account_to, account_from_valided.currency),
         {:ok, withdraw_result} <- subtract_value(account_from, value, "transfer >"),
         {:ok, _} <-
           sum_value(account_to, account_from_valided.currency, value, "transfer <") do
      {:ok, withdraw_result}
    end
  end

  def transfer(%{
        "value" => value,
        "account_id" => account_from,
        "account_to" => account_to
      })
      when (not is_binary(account_from) and is_binary(account_to)) or is_binary(value) do
    {:error, :invalid_account_id_type}
  end

  def transfer(%{
        "value" => value,
        "account_id" => account_from,
        "account_to" => account_to
      })
      when is_binary(account_from) and is_binary(account_to) and not is_binary(value) do
    {:error, :invalid_value_type}
  end

  def transfer(_), do: {:error, :invalid_arguments_type}

  defp transfer(value, account_from, account_to) do
    %{
      "value" => value,
      "account_id" => account_from,
      "account_to" => account_to
    }
    |> transfer()
  end

  @doc """
  Transfer of values ​​between multiple accounts.

  ## Examples
      {_, account} = FinancialSystem.Core.create(%{
          "name" => "Yashin Santos",
          "currency" => "BRL",
          "value" => "220",
          "email" => "xqx@xx.com",
          "password" => "B@xopn123"
        })
      {_, account2} = FinancialSystem.Core.create(%{
          "name" => "Antonio Marcos",
          "currency" => "MZN",
          "value" => "220",
          "email" => "xxzqqx@xx.com",
          "password" => "B@xopn123"
        })
      {_, account3} = FinancialSystem.Core.create(%{
          "name" => "Mateus Mathias",
          "currency" => "EUR",
          "value" => "220",
          "email" => "xxxx@xx.com",
          "password" => "B@xopn123"
        })

      split_list = [
        %FinancialSystem.Core.Split{account: account.id, percent: 49.9},
        %FinancialSystem.Core.Split{account: account3.id, percent: 50.1}]

      FinancialSystem.Core.FinancialOperations.split(%{
          "account_id" => account2.id,
          "split_list" => split_list,
          "value" => "0.2"
        })
  """
  @impl true
  def split(%{
        "account_id" => account_from,
        "split_list" => split_list,
        "value" => value
      })
      when is_binary(account_from) and is_list(split_list) and is_binary(value) do
    with {:ok, account} <- AccountRepository.find_account(:accountid, account_from),
         {:ok, _} <- FinHelper.percent_ok(split_list),
         {:ok, _} <- FinHelper.transfer_have_account_from(account_from, split_list),
         {:ok, united_accounts} <- FinHelper.unite_equal_account_split(split_list),
         {:ok, value_in_integer} <-
           Currency.amount_do(:store, value, account.currency),
         {:ok, _} <-
           FinHelper.funds(account, value_in_integer),
         {:ok, list_to_transfer} <- verify_values_from_split(value, account, united_accounts) do
      Enum.each(list_to_transfer, fn data_transfer ->
        transfer(
          data_transfer.value_to_transfer,
          account_from,
          data_transfer.account_to_transfer
        )
      end)

      {_, account_from_state} = AccountRepository.find_account(:accountid, account_from)

      {:ok, account_from_state |> format_value()}
    end
  end

  def split(%{
        "account_id" => account_from,
        "split_list" => split_list_another_format,
        "value" => value
      })
      when not is_binary(account_from) and is_list(split_list_another_format) and is_binary(value) do
    {:error, :invalid_account_id_type}
  end

  def split(%{
        "account_id" => account_from,
        "split_list" => split_list_another_format,
        "value" => value
      })
      when is_binary(account_from) and is_list(split_list_another_format) and not is_binary(value) do
    {:error, :invalid_value_type}
  end

  def split(_) do
    {:error, :invalid_arguments_type}
  end

  @doc """
  Show the financial statement from account.

  ## Examples
      {_, account} = FinancialSystem.Core.create(%{
          "name" => "Mateus Mathias",
          "currency" => "EUR",
          "value" => "220",
          "email" => "xx@xx.com",
          "password" => "B@xopn123"
        })

      FinancialSystem.Core.FinancialOperations.withdraw(%{
          "account_id" => account.id,
          "value" => "1"
        })

      FinancialSystem.Core.FinancialOperations.financial_statement(%{"id" => account.id})
  """
  @impl true
  def financial_statement(%{"email" => email}) when is_binary(email) do
    with {:ok, account} <- Helpers.get_account_or_user(:account, :email, %{"email" => email}) do
      {:ok,
       %{
         account_id: account.id,
         transactions: AccountOperations.show_financial_statement(account.id)
       }}
    end
  end

  def financial_statement(%{"email" => email}) when not is_binary(email) do
    {:error, :invalid_email_type}
  end

  def financial_statement(%{"account_id" => account_id}) when is_binary(account_id) do
    with {:ok, _} <- AccountRepository.find_account(:accountid, account_id) do
      {:ok,
       %{
         account_id: account_id,
         transactions: AccountOperations.show_financial_statement(account_id)
       }}
    end
  end

  def financial_statement(%{"account_id" => account_id}) when not is_binary(account_id) do
    {:error, :invalid_account_id_type}
  end

  defp subtract_value(account_id, value, operation)
       when is_binary(account_id) and is_binary(operation) and
              operation in ["withdraw", "transfer >"] and is_binary(value) do
    with {:ok, account} <- AccountRepository.find_account(:accountid, account_id),
         {:ok, value_in_integer} <-
           Currency.amount_do(:store, value, account.currency),
         {:ok, _} <- FinHelper.funds(account, value_in_integer) do
      {:ok,
       account
       |> AccountOperations.subtract_value_in_balance(value_in_integer, operation)
       |> format_value()}
    end
  end

  defp sum_value(account_id, currency_from, value, operation)
       when is_binary(operation) and operation in ["deposit", "transfer <"] and
              is_binary(account_id) and is_binary(value) do
    with {:ok, {account, value_in_integer}} <-
           verify_value_after_convertion(value, account_id, currency_from) do
      {:ok,
       account
       |> AccountOperations.sum_value_in_balance(value_in_integer, operation)
       |> format_value()}
    end
  end

  defp format_value(account_actual_state) do
    {:ok, value_formated} =
      Currency.amount_do(
        :show,
        account_actual_state.value,
        account_actual_state.currency
      )

    %FinancialSystem.Core.Accounts.Account{account_actual_state | value: value_formated}
  end

  defp verify_values_from_split(value, account, united_accounts) do
    with {:ok, list_to_transfer} <-
           FinHelper.division_of_values_to_make_split_transfer(united_accounts, value) do
      list_to_transfer
      |> Enum.map(fn data_transfer ->
        verify_value_after_convertion(value, data_transfer.account_to_transfer, account.currency)
      end)
      |> Enum.member?({:error, :value_is_too_low_to_convert_to_the_currency})
      |> do_verify_values_from_split(list_to_transfer)
    end
  end

  defp do_verify_values_from_split(false, list_to_transfer), do: {:ok, list_to_transfer}

  defp do_verify_values_from_split(true, _),
    do: {:error, :value_is_too_low_to_convert_to_the_currency}

  defp verify_value_after_convertion(value, account_id, currency_from) do
    with {:ok, account_to} <- AccountRepository.find_account(:accountid, account_id),
         {:ok, _} <- currency_finder().currency_is_valid(currency_from),
         {:ok, value_in_integer} <-
           Currency.convert(
             String.upcase(currency_from),
             String.upcase(account_to.currency),
             value
           ) do
      {:ok, {account_to, value_in_integer}}
    end
  end
end
