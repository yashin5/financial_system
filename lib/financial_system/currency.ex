defmodule FinancialSystem.Currency do

  def currency_rate do
    case File.read("currency_rate.json") do
      {:ok, body} -> Poison.decode!(body)
      {:error, reason} -> reason
    end
  end

  def currency_is_valid?(currency) do
    is_valid? = Map.has_key?(currency["quotes"], "USD#{String.upcase(currency)}")

    case is_valid? do
      true -> {:ok, String.upcase(currency)}
      false -> {:error, raise(ArgumentError, message: "The currency is not valid. Please, check it and try again.")}
    end
  end
end
