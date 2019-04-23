defmodule FinancialSystem.FinancialBehaviour do
  @moduledoc false
  alias FinancialSystem.{Account, Split}

  @callback create(String.t() | any(), String.t() | any(), number() | any()) ::
              {:ok, pid()} | {:error, no_return()} | no_return()
  @callback show(pid() | any()) :: Decimal.t() | no_return()
  @callback deposit(pid() | any(), String.t() | any(), number() | any()) ::
              Account.t() | no_return()
  @callback withdraw(pid() | any(), number() | any()) ::
              Account.t() | {:error, no_return()} | no_return()
  @callback transfer(number(), pid(), pid()) :: Split.t() | no_return()
  @callback split(pid() | any(), Split.t() | any(), number() | any()) ::
              [Account.t()] | {:error, no_return()} | no_return()
end
