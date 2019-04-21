defmodule FinancialSystem.Currency do
  @spec currency_rate() :: map()
  defp currency_rate do
    case File.read("currency_rate.json") do
      {:ok, body} -> Poison.decode!(body)
      {:error, reason} -> reason
    end
  end

  @spec currency_is_valid?(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def currency_is_valid?(currency) do
    is_valid? = Map.has_key?(currency_rate()["quotes"], "USD#{String.upcase(currency)}")

    case is_valid? do
      true ->
        {:ok, String.upcase(currency)}
      false ->
        {:error,
         raise(ArgumentError,
           message: "The currency is not valid. Please, check it and try again."
         )}
    end
  end

  @spec convert(String.t(), pid(), number()) :: number()
  def convert("USD", currency_to, value) do
    value * currency_rate()["quotes"]["USD#{String.upcase(currency_to)}"]
  end

  @spec convert(String.t(), String.t(), number()) :: number()
  def convert(currency_from, currency_to, value) do
    value / currency_rate()["quotes"]["USD#{String.upcase(currency_from)}"] *
      currency_rate()["quotes"]["USD#{String.upcase(currency_to)}"]
  end
end
