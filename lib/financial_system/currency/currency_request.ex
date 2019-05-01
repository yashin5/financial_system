defmodule FinancialSystem.Currency.CurrencyRequest do
  defp load_from_config do
    case File.read(get_currency_path()) do
      {:ok, body} -> Poison.decode!(body)
      {:error, reason} -> reason
    end
  end

  @doc """
    Verify if currency is valid.

  ## Examples
    FinancialSystem.Currency.CurrencyRequest.currency_is_valid("BRL")
  """
  @spec currency_is_valid(String.t()) :: {:ok, String.t()} | {:error, no_return()}
  def currency_is_valid(currency_code) do
    is_valid? = Map.has_key?(load_from_config()["quotes"], "USD#{String.upcase(currency_code)}")

    case is_valid? do
      true ->
        {:ok, String.upcase(currency_code)}

      false ->
        {:error,
         raise(ArgumentError,
           message: "The currency is not valid. Please, check it and try again."
         )}
    end
  end

  def get_from_currency(:precision, currency) do
    load_from_config()["decimal"]["USD#{currency}"]
  end

  def get_from_currency(:value, currency) do
    load_from_config()["quotes"]["USD#{currency}"]
  end

  defp get_currency_path do
    Application.get_env(:financial_system, :file)
  end
end
