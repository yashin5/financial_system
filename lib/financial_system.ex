defmodule FinancialSystem do
  # TODO

  @moduledoc false

  alias FinancialSystem.Account, as: Account
  alias FinancialSystem.CurrencyConvert, as: CurrencyConvert
  alias FinancialSystem.FinHelpers, as: FinHelpers
  alias FinancialSystem.SplitList, as: SplitList

  def get_value_in_account(%Account{value: value}) do
    value
  end

  def deposit(%Account{value: value_to, currency: currency_to} = account_to, currency_from, deposit_amount) when deposit_amount > 0 do
    CurrencyConvert.currency_is_valid?(currency_to, FinHelpers.add_value(account_to, value_to, currency_from, currency_to, deposit_amount))
  end

  def transfer(
        %Account{email: email_from, value: value_from, currency: currency_from} = account_from,
        %Account{email: email_to, value: value_to, currency: currency_to} = account_to,
        transfer_amount
      )
      when email_from != email_to and transfer_amount > 0 do
        FinHelpers.subtracts_value(account_from, value_from, transfer_amount) 

        FinHelpers.add_value(account_to, value_to, currency_from, currency_to, transfer_amount)
  end

  def split(%Account{email: email_from, value: value_from, currency: currency_from} = account_from, list_to, split_amount)
    when value_from >= split_amount and split_amount > 0 do
    if list_to_ok?(email_from, list_to) do
      raise(ArgumentError, message: "Cannot split from one account to the same.")
    else
      FinHelpers.subtracts_value(account_from, value_from, split_amount)  
      map_split(list_to, split_amount, currency_from)
    end
  end

  def do_split(account_to, split_amount, currency_from) do
    account_to
    |> Enum.map(fn %SplitList{
      account: %Account{value: value_to, currency: currency_to} = account,
      percent: percent} ->
  
      split_to = percent / 100 * split_amount
  
      FinHelpers.add_value(account, value_to, currency_from, currency_to, split_to)
    end)
  end

  def map_split(account_to, split_amount, currency_from) when split_amount > 0 do
    if percent_ok?(account_to) do 
      unite_equal_accounts(account_to) 
      |> do_split(split_amount, currency_from)
    else
      raise(ArgumentError, message: "The total percent must be 100")
    end
  end

  def list_to_ok?(email_from, list_to) do 
    Enum.map(list_to, fn %SplitList{account: %Account{email: email_to}} -> email_from == email_to end)
    |> Enum.member?(true)
  end

  def unite_equal_accounts(account_to) do
    account_to
    |> Enum.reduce(%{}, fn %SplitList{
                            account: %Account{email: email}} = sp,
                          acc ->
      Map.update(acc, email, sp, fn acc -> %{acc | percent: acc.percent + sp.percent} end)
    end)
    |> Enum.map(fn {_, res} -> res end)
  end

  def percent_ok?(account_to) do
    account_to
    |> Enum.map(fn %SplitList{percent: percent} ->
      percent
    end)
    |> Enum.sum() == 100
  end
end