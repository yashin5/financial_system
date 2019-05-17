defmodule FinancialSystem.Account do
  @moduledoc """
  This module is responsable for detemrinate the struct of accounts.
  """

  @behaviour FinancialSystem.Financial

  alias FinancialSystem.{AccountState, Currency}
  alias FinancialSystem.Currency.CurrencyImpl

  @typedoc """
    Abstract account struct type.
  """
  @type t :: %__MODULE__{
          account_id: integer(),
          name: String.t(),
          currency: String.t(),
          value: String.t()
        }

  @enforce_keys [:account_id, :name, :currency, :value]

  defstruct [:account_id, :name, :currency, :value]

  @doc """
    Create user accounts

  ## Examples
    FinancialSystem.create("Yashin Santos",  "EUR", "220")
  """
  @spec create(String.t() | any(), String.t() | any(), String.t() | any()) ::
          {:ok, Account.t()} | {:error, String.t()}
  def create(name, currency, value)
      when is_binary(name) and is_binary(currency) and is_binary(value) do
    with {:ok, currency_upcase} <- CurrencyImpl.currency_is_valid(currency),
         {:ok, value_in_integer} <- Currency.amount_do(:store, value, currency_upcase),
         true <- byte_size(name) > 0,
         {:ok, account_created} <-
           AccountState.register_account(%__MODULE__{
             account_id: AccountState.create_account_id(),
             name: name,
             currency: currency_upcase,
             value: value_in_integer
           }) do
      {:ok, account_created}
    end
  end

  def create(_, _, _) do
    {:error,
     "First and second args must be a string and third arg must be a number in type string greater than 0."}
  end
end
