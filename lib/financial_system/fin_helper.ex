defmodule FinancialSystem.FinHelper do
  @moduledoc """
  This module is responsable to help other modules with the financial operations, transforming
  a value in Decimal to show to the user, for example.
  """

  alias FinancialSystem.{Currency, Split}

  @doc """
    Convert a value to decimal and round it based on currency.

  ## Examples
    FinancialSystem.FinHelpers.to_decimal(10.502323, "CLF")
  """
  @spec to_decimal(number(), String.t()) :: Decimal.t()
  def to_decimal(value, currency) when is_number(value) and is_binary(currency) do
    with {:ok, _} <- Currency.currency_is_valid(currency) do
      case is_integer(value) do
        true -> (value / 1) |> Decimal.from_float() |> convert_round_to_iso("USD#{currency}")
        false -> Decimal.from_float(value) |> convert_round_to_iso("USD#{currency}")
      end
    end
  end

  @doc """
    Verify if the account have funds for the operation.

  ## Examples
      {_, pid} = FinancialSystem.create("Yashin Santos", "EUR", 220)
      FinancialSystem.FinHelpers.funds(pid, 220)
  """
  @spec funds(pid(), number()) :: boolean() | {:error, no_return()}
  def funds(pid, value) when is_pid(pid) and is_number(value) do
    case GenServer.call(pid, :get_data).value >= value do
      true -> true
      false -> {:error, raise(ArgumentError, message: "Does not have the necessary funds")}
    end
  end

  @doc """
    Verify if the list of split have a account from inside him.

  ## Examples
    {_, pid} = FinancialSystem.create("Yashin Santos", "EUR", 220)
    {_, pid2} = FinancialSystem.create("Antonio Marcos", "BRL", 100)
    {_, pid3} = FinancialSystem.create("Mateus Mathias", "BRL", 100)
    split_list = [%FinancialSystem.SplitDefinition{account: pid2, percent: 80}, %FinancialSystem.SplitDefinition{account: pid3, percent: 20}]
    FinancialSystem.FinHelpers.split_list_have_account_from(pid, split_list)
  """
  @spec split_list_have_account_from(pid(), list(Split.t())) ::
          boolean() | {:error, no_return()}
  def split_list_have_account_from(account_from, split_list)
      when is_pid(account_from) and is_list(split_list) do
    have_or_not =
      split_list
      |> Enum.map(fn %Split{account: account_to} -> account_from == account_to end)
      |> Enum.member?(true)

    case have_or_not do
      false ->
        false

      true ->
        {:error,
         raise(ArgumentError, message: "You can not send to the same account as you are sending")}
    end
  end

  @doc """
    Verify if the total percent is 100.

  ## Examples
    {_, pid} = FinancialSystem.create("Yashin Santos", "EUR", 220)
    {_, pid2} = FinancialSystem.create("Antonio Marcos", "BRL", 100)
    {_, pid3} = FinancialSystem.create("Mateus Mathias", "BRL", 100)
    split_list = [%FinancialSystem.SplitDefinition{account: pid2, percent: 80}, %FinancialSystem.SplitDefinition{account: pid3, percent: 20}]
    FinancialSystem.FinHelpers.split_list_have_account_from(split_list)
  """
  @spec percent_ok?(list(Split.t())) :: boolean() | {:error, no_return()}
  def percent_ok?(split_list) when is_list(split_list) do
    total_percent =
      split_list
      |> Enum.reduce(0, fn %Split{percent: percent}, acc ->
        acc + percent
      end)

    case total_percent == 100 do
      true -> true
      false -> {:error, raise(ArgumentError, message: "The total percent must be 100.")}
    end
  end

  @doc """
    Verify if the split list have a duplicated account.

  ## Examples
    {_, pid} = FinancialSystem.create("Yashin Santos", "EUR", 220)
    {_, pid2} = FinancialSystem.create("Antonio Marcos", "BRL", 100)
    {_, pid3} = FinancialSystem.create("Mateus Mathias", "BRL", 100)
    split_list = [%FinancialSystem.SplitDefinition{account: pid2, percent: 80}, %FinancialSystem.SplitDefinition{account: pid3, percent: 20}]
    FinancialSystem.FinHelpers.unite_equal_account_split(split_list)
  """
  @spec unite_equal_account_split(list(Split.t())) :: list(Split.t())
  def unite_equal_account_split(split_list) when is_list(split_list) do
    split_list
    |> Enum.reduce(%{}, fn %Split{account: account} = sp, acc ->
      Map.update(acc, account, sp, fn acc -> %{acc | percent: acc.percent + sp.percent} end)
    end)
    |> Enum.map(fn {_, resp} -> resp end)
  end

  @spec convert_round_to_iso(Decimal.t(), String.t()) :: Decimal.t()
  defp convert_round_to_iso(value, "USDBHD") do
    value
    |> Decimal.round(3)
  end

  @spec convert_round_to_iso(Decimal.t(), String.t()) :: Decimal.t()
  defp convert_round_to_iso(value, "USDBIF") do
    value
    |> Decimal.round(0)
  end

  @spec convert_round_to_iso(Decimal.t(), String.t()) :: Decimal.t()
  defp convert_round_to_iso(value, "USDCLF") do
    value
    |> Decimal.round(4)
  end

  @spec convert_round_to_iso(Decimal.t(), String.t()) :: Decimal.t()
  defp convert_round_to_iso(value, "USDCLP") do
    value
    |> Decimal.round(0)
  end

  @spec convert_round_to_iso(Decimal.t(), String.t()) :: Decimal.t()
  defp convert_round_to_iso(value, "USDDJF") do
    value
    |> Decimal.round(0)
  end

  @spec convert_round_to_iso(Decimal.t(), String.t()) :: Decimal.t()
  defp convert_round_to_iso(value, "USDGNF") do
    value
    |> Decimal.round(0)
  end

  @spec convert_round_to_iso(Decimal.t(), String.t()) :: Decimal.t()
  defp convert_round_to_iso(value, "USDIQD") do
    value
    |> Decimal.round(3)
  end

  @spec convert_round_to_iso(Decimal.t(), String.t()) :: Decimal.t()
  defp convert_round_to_iso(value, "USDISK") do
    value
    |> Decimal.round(0)
  end

  @spec convert_round_to_iso(Decimal.t(), String.t()) :: Decimal.t()
  defp convert_round_to_iso(value, "USDJOD") do
    value
    |> Decimal.round(3)
  end

  @spec convert_round_to_iso(Decimal.t(), String.t()) :: Decimal.t()
  defp convert_round_to_iso(value, "USDJPY") do
    value
    |> Decimal.round(0)
  end

  @spec convert_round_to_iso(Decimal.t(), String.t()) :: Decimal.t()
  defp convert_round_to_iso(value, "USDKMF") do
    value
    |> Decimal.round(0)
  end

  @spec convert_round_to_iso(Decimal.t(), String.t()) :: Decimal.t()
  defp convert_round_to_iso(value, "USDKRW") do
    value
    |> Decimal.round(0)
  end

  @spec convert_round_to_iso(Decimal.t(), String.t()) :: Decimal.t()
  defp convert_round_to_iso(value, "USDKWD") do
    value
    |> Decimal.round(3)
  end

  @spec convert_round_to_iso(Decimal.t(), String.t()) :: Decimal.t()
  defp convert_round_to_iso(value, "USDLYD") do
    value
    |> Decimal.round(3)
  end

  @spec convert_round_to_iso(Decimal.t(), String.t()) :: Decimal.t()
  defp convert_round_to_iso(value, "USDOMR") do
    value
    |> Decimal.round(3)
  end

  @spec convert_round_to_iso(Decimal.t(), String.t()) :: Decimal.t()
  defp convert_round_to_iso(value, "USDPYG") do
    value
    |> Decimal.round(0)
  end

  @spec convert_round_to_iso(Decimal.t(), String.t()) :: Decimal.t()
  defp convert_round_to_iso(value, "USDRWF") do
    value
    |> Decimal.round(0)
  end

  @spec convert_round_to_iso(Decimal.t(), String.t()) :: Decimal.t()
  defp convert_round_to_iso(value, "USDTND") do
    value
    |> Decimal.round(3)
  end

  @spec convert_round_to_iso(Decimal.t(), String.t()) :: Decimal.t()
  defp convert_round_to_iso(value, "USDUGX") do
    value
    |> Decimal.round(0)
  end

  @spec convert_round_to_iso(Decimal.t(), String.t()) :: Decimal.t()
  defp convert_round_to_iso(value, "USDUYI") do
    value
    |> Decimal.round(0)
  end

  @spec convert_round_to_iso(Decimal.t(), String.t()) :: Decimal.t()
  defp convert_round_to_iso(value, "USDUYW") do
    value
    |> Decimal.round(4)
  end

  @spec convert_round_to_iso(Decimal.t(), String.t()) :: Decimal.t()
  defp convert_round_to_iso(value, "USDVND") do
    value
    |> Decimal.round(0)
  end

  @spec convert_round_to_iso(Decimal.t(), String.t()) :: Decimal.t()
  defp convert_round_to_iso(value, "USDVUV") do
    value
    |> Decimal.round(0)
  end

  @spec convert_round_to_iso(Decimal.t(), String.t()) :: Decimal.t()
  defp convert_round_to_iso(value, "USDXAF") do
    value
    |> Decimal.round(0)
  end

  @spec convert_round_to_iso(Decimal.t(), String.t()) :: Decimal.t()
  defp convert_round_to_iso(value, "USDXOF") do
    value
    |> Decimal.round(0)
  end

  @spec convert_round_to_iso(Decimal.t(), String.t()) :: Decimal.t()
  defp convert_round_to_iso(value, "USDXPF") do
    value
    |> Decimal.round(0)
  end

  @spec convert_round_to_iso(Decimal.t(), String.t()) :: Decimal.t()
  defp convert_round_to_iso(value, _) do
    value
    |> Decimal.round(2)
  end
end
