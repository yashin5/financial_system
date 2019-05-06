defmodule FinancialSystem.Financial do
  @moduledoc false
  alias FinancialSystem.{Account, Split}

  @callback create(String.t() | any(), String.t() | any(), String.t() | any()) ::
              {:ok, pid()} | {:error, no_return()} | no_return()
  @callback show(pid() | any()) :: String.t() | no_return()
  @callback deposit(pid() | any(), String.t() | any(), String.t() | any()) ::
              Account.t() | no_return()
  @callback withdraw(pid() | any(), String.t() | any()) ::
              Account.t() | {:error, no_return()} | no_return()
  @callback transfer(String.t() | any(), pid() | any(), pid() | any()) :: Account.t() | no_return()
  @callback split(pid() | any(), Split.t() | any(), String.t() | any()) ::
              [Account.t()] | {:error, no_return()} | no_return()
end
