defmodule FinancialSystem.Currency do

  def currency_rate do
    case File.read("currency_rate.json") do
      {:ok, body} -> Poison.decode!(body)
      {:error, reason} -> reason
    end
  end

  def currency_is_valid?(currency) do
    is_valid? = Map.has_key?(currency_rate()["quotes"], "USD#{String.upcase(currency)}")

    case is_valid? do
      true -> {:ok, String.upcase(currency)}
      false -> {:error, raise(ArgumentError, message: "The currency is not valid. Please, check it and try again.")}
    end
  end

  def convert("USD", currency_to, value) do
    mult = &(&1 * currency_rate()["quotes"]["USD#{String.upcase(currency_to)}"])

    value
    |> mult.()
  end

  def convert(currency_from, currency_to, value) do
    div = &( &1 / currency_rate()["quotes"]["USD#{String.upcase(currency_from)}"])
    mult = &(&1 * currency_rate()["quotes"]["USD#{String.upcase(currency_to)}"])

    value
    |> div.()
    |> mult.()
  end
end
