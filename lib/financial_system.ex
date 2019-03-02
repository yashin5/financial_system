defmodule FinancialSystem do
  # TODO

  @moduledoc false

  alias FinancialSystem.Account, as: Account
  alias FinancialSystem.SplitList, as: SplitList

  def create_user(name, email, currency, initial_value) do
    %Account{name: name, email: email, currency: String.upcase(currency), value: initial_value}
  end

  def deposit(%Account{value: value_to} = account_to, deposit_amount) when deposit_amount > 0 do
    add_value(account_to, value_to, deposit_amount)
  end

  def transfer(
        %Account{email: email_from, value: value_from} = account_from,
        %Account{email: email_to, value: value_to} = account_to,
        transfer_amount
      )
      when email_from != email_to and value_from >= transfer_amount and transfer_amount > 0 do
      subtracts_value(account_from, value_from, transfer_amount) 

      add_value(account_to, value_to, transfer_amount)
  end

  def split(%Account{email: email_from, value: value_from} = account_from, list_to, split_amount)
    when value_from >= split_amount and split_amount > 0 do
    if list_to_ok?(email_from, list_to) do
      raise(ArgumentError, message: "Cannot split from one account to the same.")
    else
      subtracts_value(account_from, value_from, split_amount)  
      map_split(list_to, split_amount)
    end
  end

  def do_split(account_to, split_amount) do
    account_to
    |> Enum.map(fn %SplitList{
      account: %Account{value: value_to} = account, percent: percent} ->
  
      split_to = percent / 100 * split_amount
  
      add_value(account, value_to, split_to)
    end)
  end

  def map_split(account_to, split_amount) when split_amount > 0 do
    cond do
      percent_ok?(account_to) == true -> account_ok?(account_to) |> do_split(split_amount)
      true -> "The total percent must be 100"
    end
  end

  def list_to_ok?(email_from, list_to) do 
    Enum.map(list_to, fn %SplitList{ account: %Account{email: email_to}} -> email_from == email_to end)
    |> Enum.member?(true)
  end

  def account_ok?(account_to) do
    account_to
    |> Enum.reduce(%{}, fn %SplitList{
                            account: %Account{email: email} = account,
                            percent: percent } = sp,
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

  def subtracts_value(account_from, value_from, action_amount) do
    new_value_from = value_from - action_amount

    %Account{account_from | value: new_value_from}    
  end

  def add_value(account_to, value_to, action_amount) do
    new_value_to = action_amount + value_to

    %Account{account_to | value: new_value_to}
  end
end