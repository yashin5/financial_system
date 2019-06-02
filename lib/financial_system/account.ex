defmodule FinancialSystem.Account do
  @moduledoc """
  This module is responsable for detemrinate the struct of accounts.
  """

  alias FinancialSystem.{AccountState, Currency}

  @typedoc """
    Abstract account struct type.
  """
  @type t :: %__MODULE__{
          account_id: String.t(),
          name: String.t(),
          currency: String.t(),
          value: integer()
        }

  @enforce_keys [:account_id, :name, :currency, :value]

  defstruct [:account_id, :name, :currency, :value]

  defp currency_finder, do: Application.get_env(:financial_system, :currency_finder)

  @doc """
    Create user accounts

  ## Examples
    FinancialSystem.create("Yashin Santos",  "EUR", "220")
  """
  @spec create(String.t() | any(), String.t() | any(), String.t() | any()) ::
          {:ok, t()} | {:error, atom()}
  def create(name, currency, value)
      when is_binary(name) and is_binary(currency) and is_binary(value) do
    with {:ok, currency_upcase} <- currency_finder().currency_is_valid(currency),
         {:ok, value_in_integer} <- Currency.amount_do(:store, value, currency_upcase),
         true <- byte_size(name) > 0,
         {:ok, account_created} <-
           name
           |> new(currency_upcase, value_in_integer)
           |> AccountState.register_account() do
      {:ok, account_created}
    end
  end

  def create(name, currency, value)
      when not is_binary(name) and is_binary(currency) and is_binary(value) do
    {:error, :invalid_name}
  end

  def create(name, currency, value)
      when is_binary(name) and not is_binary(currency) and is_binary(value) do
    {:error, :invalid_currency_type}
  end

  def create(name, currency, value)
      when is_binary(name) and is_binary(currency) and not is_binary(value) do
    {:error, :invalid_value_type}
  end

  def create(_, _, _), do: {:error, :invalid_arguments_type}

  defp new(name, currency, value) do
    %__MODULE__{
      account_id: create_account_id(),
      name: name,
      currency: currency,
      value: value
    }
  end

  defp create_account_id do
    UUID.uuid4()
  end

  def delete(account_id) when is_binary(account_id) do
    with {:ok, _} <- AccountState.account_exist(account_id) do
      AccountState.delete_account(account_id)
    end
  end

  def delete(_), do: {:error, :invalid_account_id_type}
end
