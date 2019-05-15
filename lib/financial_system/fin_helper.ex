defmodule FinancialSystem.FinHelper do
  @moduledoc """
  This module is responsable to help other modules with the financial operations.
  """

  alias FinancialSystem.{Split, AccountState, Currency}

  @doc """
    Verify if the account have funds for the operation.

  ## Examples
      {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")

      FinancialSystem.FinHelpers.funds(account.account_id, 220)
  """
  @spec funds(String.t(), number()) :: {:ok, boolean()} | {:error, no_return()} | no_return()
  def funds(account_id, value) when is_binary(account_id) and is_number(value) do
    (AccountState.show(account_id).value >= value)
    |> do_funds()
  end

  def funds(_, _), do: {:error, "Check the account ID and de value."}

  defp do_funds(true), do: {:ok, true}

  defp do_funds(false),
    do: {:error, "Does not have the necessary funds"}

  @doc """
    Verify if the list of split have a account from inside him.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")
    {_, account2} = FinancialSystem.create("Antonio Marcos", "BRL", "100")
    {_, account3} = FinancialSystem.create("Mateus Mathias", "BRL", "100")
    split_list = [%FinancialSystem.Split{account: account.account_id, percent: 80}, %FinancialSystem.Split{account: account3.account_id, percent: 20}]

    FinancialSystem.FinHelper.transfer_have_account_from(account2.account_id, split_list)
  """
  @spec transfer_have_account_from(String.t() | any(), list(Split.t()) | String.t() | any()) ::
          {:ok, boolean()} | {:error, String.t()}
  def transfer_have_account_from(account_from, split_list)
      when is_binary(account_from) and is_list(split_list) do
    split_list
    |> Enum.map(&have_or_not(&1))
    |> Enum.member?(account_from)
    |> do_transfer_have_account_from()
  end

  def transfer_have_account_from(account_from, account_to)
      when is_binary(account_from) and is_binary(account_to) do
    (account_from == account_to)
    |> do_transfer_have_account_from()
  end

  def transfer_have_account_from(_, _),
    do:
      {:error,
       "First arg must be a account ID and second arg must be a account ID or a Split struct"}

  defp do_transfer_have_account_from(false), do: {:ok, true}

  defp do_transfer_have_account_from(true),
    do: {:error, "You can not send to the same account as you are sending"}

  defp have_or_not(%Split{account: account_to}) do
    account_to
  end

  @doc """
    Verify if the total percent is 100.

  ## Examples
    {_, account} = FinancialSystem.create("Yashin Santos", "EUR", "220")
    {_, account3} = FinancialSystem.create("Mateus Mathias", "BRL", "100")
    split_list = [%FinancialSystem.Split{account: account.account_id, percent: 80}, %FinancialSystem.Split{account: account3.account_id, percent: 20}]

    FinancialSystem.FinHelper.percent_ok(split_list)
  """
  @spec percent_ok(list(Split.t()) | any()) :: {:ok, boolean()} | {:error, String.t()}
  def percent_ok(split_list) when is_list(split_list) do
    split_list
    |> Enum.reduce(0, fn %Split{percent: percent}, acc -> acc + percent end)
    |> Kernel.==(100)
    |> do_percent_ok()
  end

  def percent_ok(_), do: {:error, "Check if the split list is valid."}

  defp do_percent_ok(true), do: {:ok, true}

  defp do_percent_ok(false),
    do: {:error, "The total percent must be 100."}

  @doc """
    Unite the duplicated accounts in split_list.

  ## Examples
    {_, account2} = FinancialSystem.create("Antonio Marcos", "BRL", "100")
    {_, account3} = FinancialSystem.create("Mateus Mathias", "BRL", "100")
    split_list = [%FinancialSystem.Split{account: account2.account_id, percent: 80}, %FinancialSystem.Split{account: account2.account_id, percent: 20}]

    FinancialSystem.FinHelper.unite_equal_account_split(split_list)
  """
  @spec unite_equal_account_split(list(Split.t())) ::
          {:ok, list(Split.t())} | {:error, String.t()}
  def unite_equal_account_split(split_list) when is_list(split_list) do
    {:ok,
     split_list
     |> Enum.reduce(%{}, fn %Split{account: account} = sp, acc ->
       Map.update(acc, account, sp, fn acc -> %{acc | percent: acc.percent + sp.percent} end)
     end)
     |> Enum.map(fn {_, resp} -> resp end)}
  end

  def unite_equal_account_split(_),
    do: {:error, "Check if the split list is valid."}

  def division_of_values_to_make_split_transfer(percent, value) do
    {:ok, percent_in_decimal} = Currency.to_decimal(percent)

    percent_in_decimal
        |> Decimal.div(100)
        |> Decimal.mult(Decimal.new(value))
        |> Decimal.to_string()
  end
end
