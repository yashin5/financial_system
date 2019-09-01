defmodule FinancialSystem.Core.FinHelper do
  @moduledoc """
  This module is responsable to help other modules with the financial operations.
  """

  alias FinancialSystem.Core.{
    Accounts.Account,
    Accounts.AccountRepository,
    Currency,
    Split
  }

  @doc """
    Verify if the account have funds for the operation.

  ## Examples
      {_, account} = FinancialSystem.Core.create(%{
        "name" => "Yashin Santos",
        "currency" => "EUR",
        "value" => "220",
        "email" => "xx@xx.com",
        "password" => "B@xopn123"
      })

      FinancialSystem.Core.FinHelper.funds(account.id, 220)
  """

  @spec funds(Account.t(), integer()) :: {:ok, boolean()} | {:error, atom()}
  def funds(%Account{value: account_value}, value)
      when is_number(value) do
    account_value
    |> Kernel.>=(value)
    |> do_funds()
  end

  def funds(_, value) when is_integer(value) do
    {:error, :invalid_account_type}
  end

  def funds(%Account{}, value) when not is_integer(value) do
    {:error, :invalid_value_type}
  end

  def funds(_, _), do: {:error, :invalid_arguments_type}

  defp do_funds(true), do: {:ok, true}

  defp do_funds(false),
    do: {:error, :do_not_have_funds}

  @doc """
    Verify if the list of split have a account from inside him.

  ## Examples
    {_, account} = FinancialSystem.Core.create(%{
        "name" => "Yashin Santos",
        "currency" => "EUR",
        "value" => "220",
        "email" => "xx@xx.com",
        "password" => "B@xopn123"
      })
    {_, account2} = FinancialSystem.Core.create(%{
        "name" => "Yashin Santos",
        "currency" => "EUR",
        "value" => "220",
        "email" => "xx@xx.com",
        "password" => "B@xopn123"
      })
    {_, account3} = FinancialSystem.Core.create(%{
        "name" => "Yashin Santos",
        "currency" => "EUR",
        "value" => "220",
        "email" => "xx@xx.com",
        "password" => "B@xopn123"
      })
    split_list = [%FinancialSystem.Core.Split{account: account.id, percent: 80}, %FinancialSystem.Core.Split{account: account3.id, percent: 20}]

    FinancialSystem.Core.FinHelper.transfer_have_account_from(account2.id, split_list)
  """
  @spec transfer_have_account_from(String.t() | any(), list(Split.t()) | String.t() | any()) ::
          {:ok, boolean()} | {:error, atom()}
  def transfer_have_account_from(account_from, split_list)
      when is_binary(account_from) and is_list(split_list) do
    with {:ok, _} <- AccountRepository.find_account(account_from) do
      split_list
      |> Enum.map(&have_or_not(&1))
      |> Enum.member?(account_from)
      |> do_transfer_have_account_from()
    end
  end

  @doc """
    Verify if the accounts are the same.

  ## Examples
    {_, account} = FinancialSystem.Core.create(%{
        "name" => "Yashin Santos",
        "currency" => "EUR",
        "value" => "220",
        "email" => "xx@xx.com",
        "password" => "B@xopn123"
      })
    {_, account2} = FinancialSystem.Core.create(%{
        "name" => "Yashin Santos",
        "currency" => "EUR",
        "value" => "220",
        "email" => "xx@xx.com",
        "password" => "B@xopn123"
      })

    FinancialSystem.Core.FinHelper.transfer_have_account_from(account2.id, account.id)
  """
  def transfer_have_account_from(account_from, account_to)
      when is_binary(account_from) and is_binary(account_to) do
    with {:ok, _} <- AccountRepository.find_account(account_from),
         {:ok, _} <- AccountRepository.find_account(account_to) do
      account_from
      |> Kernel.==(account_to)
      |> do_transfer_have_account_from()
    end
  end

  def transfer_have_account_from(account_from, account_to)
      when not is_binary(account_from) or is_binary(account_to) or is_list(account_to) do
    {:error, :invalid_account_id_type}
  end

  def transfer_have_account_from(account_from, account_to)
      when is_binary(account_from) or not is_binary(account_to) or not is_list(account_to) do
    {:error, :invalid_type_to_compare}
  end

  def transfer_have_account_from(_, _), do: {:error, :invalid_arguments_type}

  defp do_transfer_have_account_from(false), do: {:ok, true}

  defp do_transfer_have_account_from(true),
    do: {:error, :cannot_send_to_the_same}

  defp have_or_not(%Split{account: account_to}) do
    account_to
  end

  @doc """
    Verify if the total percent is 100.

  ## Examples
    {_, account} = FinancialSystem.Core.create(%{
        "name" => "Yashin Santos",
        "currency" => "EUR",
        "value" => "220",
        "email" => "xx@xx.com",
        "password" => "B@xopn123"
      })
    {_, account3} = FinancialSystem.Core.create(%{
        "name" => "Yashin Santos",
        "currency" => "EUR",
        "value" => "220",
        "email" => "xx@xx.com",
        "password" => "B@xopn123"
      })
    split_list = [%FinancialSystem.Core.Split{account: account.id, percent: 80}, %FinancialSystem.Core.Split{account: account3.id, percent: 20}]

    FinancialSystem.Core.FinHelper.percent_ok(split_list)
  """
  @spec percent_ok(list(Split.t()) | any()) :: {:ok, boolean()} | {:error, atom()}
  def percent_ok(split_list) when is_list(split_list) do
    split_list
    |> Enum.reduce(0, fn %Split{percent: percent}, acc -> acc + percent end)
    |> Kernel.==(100)
    |> do_percent_ok()
  end

  def percent_ok(_), do: {:error, :invalid_split_list_type}

  defp do_percent_ok(true), do: {:ok, true}

  defp do_percent_ok(false),
    do: {:error, :invalid_total_percent}

  @doc """
    Unite the duplicated accounts in split_list.

  ## Examples
    {_, account2} = FinancialSystem.Core.create(%{
        "name" => "Yashin Santos",
        "currency" => "EUR",
        "value" => "220",
        "email" => "xx@xx.com",
        "password" => "B@xopn123"
      })
    {_, account3} = FinancialSystem.Core.create(%{
        "name" => "Yashin Santos",
        "currency" => "EUR",
        "value" => "220",
        "email" => "xx@xx.com",
        "password" => "B@xopn123"
      })
    split_list = [%FinancialSystem.Core.Split{account: account2.id, percent: 80}, %FinancialSystem.Core.Split{account: account2.id, percent: 20}]

    FinancialSystem.Core.FinHelper.unite_equal_account_split(split_list)
  """
  @spec unite_equal_account_split(list(Split.t()) | any()) ::
          {:ok, list(Split.t())} | {:error, atom()}
  def unite_equal_account_split(split_list) when is_list(split_list) do
    {:ok,
     split_list
     |> Enum.reduce(%{}, fn %Split{account: account} = sp, acc ->
       Map.update(acc, account, sp, fn acc -> %{acc | percent: acc.percent + sp.percent} end)
     end)
     |> Enum.map(fn {_, resp} -> resp end)}
  end

  def unite_equal_account_split(_),
    do: {:error, :invalid_split_list_type}

  @doc """
    Divides the amount to be transferred to each account in a split.

  ## Examples
    {_, account2} = FinancialSystem.Core.create(%{
        "name" => "Yashin Santos",
        "currency" => "EUR",
        "value" => "220",
        "email" => "xx@xx.com",
        "password" => "B@xopn123"
      })
    {_, account3} = FinancialSystem.Core.create(%{
        "name" => "Yashin Santos",
        "currency" => "EUR",
        "value" => "220",
        "email" => "xx@xx.com",
        "password" => "B@xopn123"
      })
    split_list = [%FinancialSystem.Core.Split{account: account2.id, percent: 80}, %FinancialSystem.Core.Split{account: account2.id, percent: 20}]

    FinancialSystem.Core.FinHelper.division_of_values_to_make_split_transfer(split_list, 100)
  """
  @spec division_of_values_to_make_split_transfer(list(Split.t()) | any(), String.t() | any()) ::
          {:ok, list(map())} | {:error, atom()}
  def division_of_values_to_make_split_transfer(split_list, value)
      when is_list(split_list) and is_binary(value) do
    {:ok,
     split_list
     |> Enum.map(fn %Split{account: account_to, percent: percent} ->
       {:ok, percent_in_decimal} = Currency.to_decimal(percent)

       %{
         value_to_transfer:
           percent_in_decimal
           |> Decimal.div(100)
           |> Decimal.mult(Decimal.new(value))
           |> Decimal.to_string(),
         account_to_transfer: account_to
       }
     end)}
  end

  def division_of_values_to_make_split_transfer(split_list, value)
      when not is_list(split_list) and is_binary(value) do
    {:error, :invalid_split_list_type}
  end

  def division_of_values_to_make_split_transfer(split_list, value)
      when is_list(split_list) and not is_binary(value) do
    {:error, :invalid_value_type}
  end
end
