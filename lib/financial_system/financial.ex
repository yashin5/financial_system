defmodule FinancialSystem.Financial do
  @moduledoc false
  alias FinancialSystem.{Account, Split}

  @callback show(String.t() | any()) :: {:ok, String.t()} | {:error, String.t()}
  @callback deposit(String.t() | any(), String.t() | any(), String.t() | any()) ::
              {:ok, Account.t()} | {:error, String.t()}
  @callback withdraw(String.t() | any(), String.t() | any()) ::
              {:ok, Account.t()} | {:error, String.t()}
  @callback transfer(String.t() | any(), String.t() | any(), String.t() | any()) ::
              {:ok, Account.t()} | {:error, String.t()}
  @callback split(String.t() | any(), Split.t() | any(), String.t() | any()) ::
              {:ok, Account.t()} | {:error, String.t()}
end
