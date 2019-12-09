defmodule FinancialSystem.Core.Currency.CurrencyImpl do
  @moduledoc """
  This module is responsable to simulate  requests to an API.
  """
  @behaviour FinancialSystem.Core.Currency.CurrencyBehaviour

  alias FinancialSystem.Core.Currency.CurrencyBehaviour

  defp get_currency_path do
    Application.get_env(:core, :file)
  end

  defp load_from_config do
    :core
    |> :code.priv_dir()
    |> Path.join(get_currency_path())
    |> File.read()
    |> do_load_from_config()
  end

  defp do_load_from_config({:ok, body}), do: Jason.decode!(body)

  @doc """
  Get all currencies from application
  """
  @callback get_currencies :: [String.t()]
  def get_currencies do
    Map.keys(load_from_config()["quotes"])
    |> Enum.map(fn item -> String.slice(item, 3..-1) end)
  end

  @doc """
  Verify if currency is valid.

  ## Examples
    FinancialSystem.Core.Currency.CurrencyImpl.currency_is_valid("BRL")
  """
  @impl CurrencyBehaviour
  def currency_is_valid(currency) when byte_size(currency) > 0 and is_binary(currency) do
    load_from_config()["quotes"]
    |> Map.has_key?("USD#{String.upcase(currency)}")
    |> do_currency_is_valid(currency)
  end

  def currency_is_valid(_), do: {:error, :invalid_currency_type}

  defp do_currency_is_valid(true, currency), do: {:ok, String.upcase(currency)}

  defp do_currency_is_valid(false, _) do
    {:error, :currency_is_not_valid}
  end

  @doc """
  Get the decimal precision of a currency.

  ## Examples
      FinancialSystem.Core.Currency.CurrencyImpl.get_from_currency(:precision, "BRL")
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
      FinancialSystem.Core.Currency.CurrencyImpl.get_from_currency(:value, "BRL")
  """
  def get_from_currency(:value = operation, currency)
      when is_atom(operation) and is_binary(currency) and byte_size(currency) > 0 do
    with {:ok, _} <- currency_is_valid(currency) do
      {:ok, load_from_config()["quotes"]["USD#{currency}"]}
    end
  end
end
