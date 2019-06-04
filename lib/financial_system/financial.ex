defmodule FinancialSystem.Financial do
  @moduledoc false
  alias FinancialSystem.{Accounts.AccountsRepo, Split}

  @callback show(String.t() | any()) :: {:ok, String.t()} | {:error, atom()}
  @callback deposit(String.t() | any(), String.t() | any(), String.t() | any()) ::
              {:ok, AccountsRepo.t()}
              | {:error, atom()}
              | no_return()
  @callback withdraw(String.t() | any(), String.t() | any()) ::
              {:ok, AccountsRepo.t()}
              | {:error, atom()}
              | atom()
              | no_return()
  @callback transfer(String.t() | any(), String.t() | any(), String.t() | any()) ::
              {:ok, AccountsRepo.t()}
              | {:error, atom()}
              | no_return()
  @callback split(String.t() | any(), list(Split.t()) | any(), String.t() | any()) ::
              {:ok, AccountsRepo.t()}
              | {:error, atom()}
              | no_return()
end
