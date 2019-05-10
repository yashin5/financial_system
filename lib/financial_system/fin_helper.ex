defmodule FinancialSystem.FinHelper do
  @moduledoc """
  This module is responsable to help other modules with the financial operations.
  """

  alias FinancialSystem.Split

  @doc """
    Verify if the account have funds for the operation.

  ## Examples
      {_, pid} = FinancialSystem.create("Yashin Santos", "EUR", "220")

      FinancialSystem.FinHelpers.funds(pid, 220)
  """
  @spec funds(pid(), number()) :: {:ok, boolean()} | {:error, no_return()} | no_return()
  def funds(pid, value) when is_pid(pid) and is_number(value) do
    (GenServer.call(pid, :get_data).value >= value)
    |> do_funds()
  end

  def funds(_, _), do: {:error, "Check the pid and de value."}

  defp do_funds(true), do: {:ok, true}

  defp do_funds(false),
    do: {:error, "Does not have the necessary funds"}

  @doc """
    Verify if the list of split have a account from inside him.

  ## Examples
    {_, pid} = FinancialSystem.create("Yashin Santos", "EUR", "220")
    {_, pid2} = FinancialSystem.create("Antonio Marcos", "BRL", "100")
    {_, pid3} = FinancialSystem.create("Mateus Mathias", "BRL", "100")
    split_list = [%FinancialSystem.Split{account: pid2, percent: 80}, %FinancialSystem.Split{account: pid3, percent: 20}]

    FinancialSystem.FinHelpers.transfer_have_account_from(pid, split_list)
  """
  @spec transfer_have_account_from(pid() | any(), list(Split.t()) | pid() | any()) ::
          {:ok, boolean()} | {:error, no_return()} | no_return()
  def transfer_have_account_from(account_from, split_list)
      when is_pid(account_from) and is_list(split_list) do
    split_list
    |> Enum.map(&have_or_not(&1))
    |> Enum.member?(account_from)
    |> do_transfer_have_account_from()
  end

  @doc """
    Verify if the list of split have a account from inside him.

  ## Examples
    {_, pid} = FinancialSystem.create("Yashin Santos", "EUR", "220")
    {_, pid2} = FinancialSystem.create("Antonio Marcos", "BRL", "100")

    FinancialSystem.FinHelpers.transfer_have_account_from(pid, pid2)
  """
  def transfer_have_account_from(account_from, account_to)
      when is_pid(account_from) and is_pid(account_to) do
    (account_from == account_to)
    |> do_transfer_have_account_from()
  end

  def transfer_have_account_from(_, _),
    do: {:error, "First arg must be a pid and second arg must be a pid or a Split struct"}

  defp do_transfer_have_account_from(false), do: {:ok, true}

  defp do_transfer_have_account_from(true),
    do: {:error, "You can not send to the same account as you are sending"}

  defp have_or_not(%Split{account: account_to}) do
    account_to
  end

  @doc """
    Verify if the total percent is 100.

  ## Examples
    {_, pid} = FinancialSystem.create("Yashin Santos", "EUR", "220")
    {_, pid2} = FinancialSystem.create("Antonio Marcos", "BRL", "100")
    {_, pid3} = FinancialSystem.create("Mateus Mathias", "BRL", "100")
    split_list = [%FinancialSystem.SplitDefinition{account: pid2, percent: 80}, %FinancialSystem.SplitDefinition{account: pid3, percent: 20}]

    FinancialSystem.FinHelpers.percent_ok(split_list)
  """
  @spec percent_ok(list(Split.t()) | any()) :: boolean() | {:error, no_return()} | no_return()
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
    {_, pid} = FinancialSystem.create("Yashin Santos", "EUR", "220")
    {_, pid2} = FinancialSystem.create("Antonio Marcos", "BRL", "100")
    {_, pid3} = FinancialSystem.create("Mateus Mathias", "BRL", "100")
    split_list = [%FinancialSystem.SplitDefinition{account: pid2, percent: 80}, %FinancialSystem.SplitDefinition{account: pid3, percent: 20}]

    FinancialSystem.FinHelpers.unite_equal_account_split(split_list)
  """
  @spec unite_equal_account_split(list(Split.t())) :: list(Split.t()) | no_return()
  def unite_equal_account_split(split_list) when is_list(split_list) do
    split_list
    |> Enum.reduce(%{}, fn %Split{account: account} = sp, acc ->
      Map.update(acc, account, sp, fn acc -> %{acc | percent: acc.percent + sp.percent} end)
    end)
    |> Enum.map(fn {_, resp} -> resp end)
  end

  def unite_equal_account_split(_),
    do: {:error, "Check if the split list is valid."}
end
