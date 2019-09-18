defmodule FinancialSystem.Core.Financial do
  @moduledoc false
  alias FinancialSystem.Core.{Accounts.Account, Accounts.Transaction, Split}

  @callback show(String.t() | any()) :: {:ok, String.t()} | {:error, atom()}
  @callback deposit(%{
              account_id: String.t() | any(),
              currency: String.t() | any(),
              value: String.t() | any()
            }) ::
              {:ok, Account.t()}
              | {:error, atom()}
              | no_return()

  @callback withdraw(%{
              account_id: String.t() | any(),
              value: String.t() | any()
            }) ::
              {:ok, Account.t()}
              | {:error, atom()}
              | atom()
              | no_return()
  @callback transfer(%{
              value: String.t() | any(),
              account_from: String.t() | any(),
              account_to: String.t() | any()
            }) ::
              {:ok, Account.t()}
              | {:error, atom()}
              | no_return()
  @callback split(%{
              account_id_from: String.t() | any(),
              split_list: list(Split.t()) | any(),
              value: String.t() | any()
            }) ::
              {:ok, Account.t()}
              | {:error, atom()}
              | no_return()

  @callback financial_statement(%{account_id: String.t()} | %{email: String.t()}) ::
              {:ok, Transaction.t()} | {:error, atom()} | no_return()
end
