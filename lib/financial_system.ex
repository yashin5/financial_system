defmodule FinancialSystem do
  @moduledoc """
  This module is responsable for all the transactions:
  deposit, transfer, split transfer and show the account balance .
  """

  alias FinancialSystem.Account, as: Account
  alias FinancialSystem.CurrencyConvert, as: CurrencyConvert
  alias FinancialSystem.FinHelpers, as: FinHelpers
  alias FinancialSystem.SplitList, as: SplitList

  @doc """
  Show the value in account.
  ## Example
      iex> account = FinancialSystem.CreateAccount.create_user("This", "email@email.com", "BRL", 100)
      iex> FinancialSystem.get_value_in_account(account)
      Decimal.add(100,0) |> Decimal.round(1)
  """
  @spec get_value_in_account(FinancialSystem.Account.t()) :: any()
  def get_value_in_account(%Account{value: value}) do
    value
  end

  @doc """
  Deposit a value in account.
  ## Example
      iex> account = FinancialSystem.CreateAccount.create_user("This", "email@email.com", "BRL", 100)
      iex> FinancialSystem.deposit(account, "BRL", 100)
      %FinancialSystem.Account{currency: "BRL", email: "email@email.com", name: "This", value: Decimal.add(200,0) |> Decimal.round(2)}
  """
  @spec deposit(FinancialSystem.Account.t(), binary(), number()) :: any()
  def deposit(
        %Account{value: value_to, currency: currency_to} = account_to,
        currency_from,
        deposit_amount
      )
      when deposit_amount > 0 do
    CurrencyConvert.currency_is_valid?(
      currency_to,
      FinHelpers.add_value(account_to, value_to, currency_from, currency_to, deposit_amount)
    )
  end

  @doc """
  Transfer value between accounts.
  ## Example
      iex> account = FinancialSystem.CreateAccount.create_user("This", "email@email.com", "BRL", 100)
      iex> account2 = FinancialSystem.CreateAccount.create_user("is", "this@email.com", "BRL", 100)
      iex> FinancialSystem.transfer(account2, account, 100)
      %FinancialSystem.Account{currency: "BRL", email: "email@email.com", name: "This", value: Decimal.add(200,0) |> Decimal.round(2)}
  """
  @spec transfer(FinancialSystem.Account.t(), FinancialSystem.Account.t(), pos_integer()) ::
          FinancialSystem.Account.t()
  def transfer(
        %Account{email: email_from, value: value_from, currency: currency_from} = account_from,
        %Account{email: email_to, value: value_to, currency: currency_to} = account_to,
        transfer_amount
      )
      when email_from != email_to and transfer_amount > 0 do
    FinHelpers.subtracts_value(account_from, value_from, transfer_amount)

    FinHelpers.add_value(account_to, value_to, currency_from, currency_to, transfer_amount)
  end

  @doc """
  Transfer value between accounts.
  ## Example
      iex> account = FinancialSystem.CreateAccount.create_user("This", "email@email.com", "BRL", 100)
      iex> account2 = FinancialSystem.CreateAccount.create_user("is", "this@email.com", "BRL", 100)
      iex> list = [%FinancialSystem.SplitList{account: account, percent: 100}]
      iex> FinancialSystem.split(account2, list, 100)
      [%FinancialSystem.Account{currency: "BRL", email: "email@email.com", name: "This", value: Decimal.add(200,0) |> Decimal.round(2)}]
  """
  @spec split(FinancialSystem.Account.t(), any(), binary() | integer() | Decimal.t()) :: [any()]
  def split(
        %Account{email: email_from, value: value_from, currency: currency_from} = account_from,
        list_to,
        split_amount
      )
      when value_from >= split_amount and split_amount > 0 do
    if list_to_ok?(email_from, list_to) do
      raise(ArgumentError, message: "Cannot split from one account to the same.")
    else
      FinHelpers.subtracts_value(account_from, value_from, split_amount)
      map_split(list_to, split_amount, currency_from)
    end
  end

  @doc """
  Make the division of values.
  ## Example
      iex> account = FinancialSystem.CreateAccount.create_user("This", "email@email.com", "BRL", 100)
      iex> list = [%FinancialSystem.SplitList{account: account, percent: 100}]
      iex> FinancialSystem.do_split(list, 100, "BRL")
      [%FinancialSystem.Account{currency: "BRL", email: "email@email.com", name: "This", value: Decimal.add(200,0) |> Decimal.round(2)}]
  """
  @spec do_split(any(), any(), any()) :: [any()]
  def do_split(account_to, split_amount, currency_from) do
    account_to
    |> Enum.map(fn %SplitList{
                     account: %Account{value: value_to, currency: currency_to} = account,
                     percent: percent
                   } ->
      split_to = percent / 100 * split_amount

      FinHelpers.add_value(account, value_to, currency_from, currency_to, split_to)
    end)
  end

  @doc """
  Treat the error in split.
  ## Example
      iex> account = FinancialSystem.CreateAccount.create_user("This", "email@email.com", "BRL", 100)
      iex> list = [%FinancialSystem.SplitList{account: account, percent: 100}]
      iex> FinancialSystem.map_split(list, 100, "BRL")
      [%FinancialSystem.Account{currency: "BRL", email: "email@email.com", name: "This", value: Decimal.add(200,0) |> Decimal.round(2)}]
  """
  @spec map_split(any(), any(), any()) :: [any()]
  def map_split(account_to, split_amount, currency_from) when split_amount > 0 do
    if percent_ok?(account_to) do
      account_to
      |> unite_equal_accounts()
      |> do_split(split_amount, currency_from)
    else
      raise(ArgumentError, message: "The total percent must be 100")
    end
  end

  @doc """
  Treat the error in split.
  ## Example
      iex> account = FinancialSystem.CreateAccount.create_user("This", "email@email.com", "BRL", 100)
      iex> list = [%FinancialSystem.SplitList{account: account, percent: 100}]
      iex> FinancialSystem.list_to_ok?("email@email.com", list)
      true
  """
  @spec list_to_ok?(any(), any()) :: boolean()
  def list_to_ok?(email_from, list_to) do
    list_to
    |> Enum.map(fn %SplitList{account: %Account{email: email_to}} ->
      email_from == email_to
    end)
    |> Enum.member?(true)
  end

  @doc """
  Check if have equal accounts and unite them
  ## Example
      iex> account = FinancialSystem.CreateAccount.create_user("This", "email@email.com", "BRL", 100)
      iex> list = [%FinancialSystem.SplitList{account: account, percent: 90}, %FinancialSystem.SplitList{account: account, percent: 10}]
      iex> unite_equal_accounts = FinancialSystem.unite_equal_accounts(list)
      iex> Enum.reduce(unite_equal_accounts, %{}, fn x, acc -> Map.put(acc, :percent, x.percent) end)
      %{percent: 100}
  """
  @spec unite_equal_accounts(any()) :: [any()]
  def unite_equal_accounts(account_to) do
    account_to
    |> Enum.reduce(%{}, fn %SplitList{account: %Account{email: email}} = sp, acc ->
      Map.update(acc, email, sp, fn acc -> %{acc | percent: acc.percent + sp.percent} end)
    end)
    |> Enum.map(fn {_, res} -> res end)
  end

  @doc """
  Make the struct for split.
  ## Example
      iex> account = FinancialSystem.CreateAccount.create_user("This", "email@email.com", "BRL", 100)
      iex> list = [%FinancialSystem.SplitList{account: account, percent: 100}]
      iex> FinancialSystem.percent_ok?(list)
      true
  """
  @spec percent_ok?(any()) :: boolean()
  def percent_ok?(account_to) do
    account_to
    |> Enum.map(fn %SplitList{percent: percent} ->
      percent
    end)
    |> Enum.sum() == 100
  end
end
