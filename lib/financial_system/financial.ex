defmodule FinancialSystem.Financial do
  @moduledoc false
  alias FinancialSystem.{Account, Split}

  @callback create(String.t() | any(), String.t() | any(), String.t() | any()) ::
              {:ok, pid()} | {:error, no_return()} | no_return()
  @callback show(pid() | any()) :: String.t() | no_return()
  @callback deposit(pid() | any(), String.t() | any(), String.t() | any()) ::
              {:ok, Account.t()} | {:error, String.t()}
  @callback withdraw(pid() | any(), String.t() | any()) ::
              {:ok, Account.t()} | {:error, String.t()}
  @callback transfer(String.t() | any(), pid() | any(), pid() | any()) ::
              {:ok, Account.t()} | {:error, String.t()}
  @callback split(pid() | any(), Split.t() | any(), String.t() | any()) ::
              {:ok, Account.t()} | {:error, String.t()}
end
