defmodule FinancialSystem.Currency.CurrencyImpl do
  @moduledoc """
  This module is responsable to simulate  requests to an API.
  """
  @behaviour FinancialSystem.Currency.CurrencyBehaviour

  alias FinancialSystem.Currency.CurrencyBehaviour

  defp load_from_config do
    get_currency_path()
    |> File.read()
    |> do_load_from_config()
  end

  defp do_load_from_config({:ok, body}), do: Poison.decode!(body)

  defp do_load_from_config({:error, reason}), do: reason

  defp get_currency_path do
    Application.get_env(:financial_system, :file)
  end

  @doc """
    Verify if currency is valid.

  ## Examples
    FinancialSystem.Currency.CurrencyImpl.currency_is_valid("BRL")
  """
  @impl CurrencyBehaviour
  def currency_is_valid(currency) when byte_size(currency) > 0 and is_binary(currency) do
    load_from_config()["quotes"]
    |> Map.has_key?("USD#{String.upcase(currency)}")
    |> do_currency_is_valid(currency)
  end

  defp do_currency_is_valid(true, currency), do: {:ok, String.upcase(currency)}

  defp do_currency_is_valid(false, _) do
    {:error, :currency_is_not_valid}
  end

  @doc """
    Get the decimal precision of a currency.

  ## Examples
    FinancialSystem.Currency.CurrencyImpl.get_from_currency(:precision, "BRL")
  """
  @impl CurrencyBehaviour
  def get_from_currency(:precision = operation, currency)
      when is_atom(operation) and is_binary(currency) and byte_size(currency) > 0 do
    with {:ok, _} <- currency_is_valid(currency) do
      {:ok, load_from_config()["decimal"]["USD#{currency}"]}
    end
  end

  @doc """
    Get the current value of currency.

  ## Examples
    FinancialSystem.Currency.CurrencyImpl.get_from_currency(:value, "BRL")
  """
  def get_from_currency(:value = operation, currency)
      when is_atom(operation) and is_binary(currency) and byte_size(currency) > 0 do
    with {:ok, _} <- currency_is_valid(currency) do
      {:ok, load_from_config()["quotes"]["USD#{currency}"]}
    end
  end
end
