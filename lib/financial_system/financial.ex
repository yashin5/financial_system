defmodule FinancialSystem.Financial do
  @moduledoc false
  alias FinancialSystem.{Account, Split}

  @callback show(String.t() | any()) :: {:ok, String.t()} | {:error, String.t()}
  @callback deposit(String.t() | any(), String.t() | any(), String.t() | any()) ::
              {:ok, Account.t()} | {:error, String.t()}
  @callback withdraw(String.t() | any(), String.t() | any()) ::
              {:ok, Account.t()}
              | {:error, :invalid_account_id_type | :invalid_arguments_type | :invalid_value_type}
  @callback transfer(String.t() | any(), String.t() | any(), String.t() | any()) ::
              {:ok, Account.t()}
              | {:error, :invalid_account_id_type | :invalid_arguments_type | :invalid_value_type}
  @callback split(String.t() | any(), list(Split.t()) | any(), String.t() | any()) ::
              {:ok, Account.t()} | {:error, String.t()}
end
