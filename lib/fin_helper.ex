defmodule FinancialSystem.FinHelper do
  def to_decimal(value, currency) when is_number(value) do
    case is_integer(value) do
      true -> (value / 1) |> Decimal.from_float() |> convert_round_to_iso(currency)
      false -> Decimal.from_float(value) |> convert_round_to_iso(currency)
    end
  end

  def convert_round_to_iso(value, "USDBHD") do
    value
    |> Decimal.round(3)
  end

  def convert_round_to_iso(value, "USDBIF") do
    value
    |> Decimal.round(0)
  end

  def convert_round_to_iso(value, "USDCLF") do
    value
    |> Decimal.round(4)
  end

  def convert_round_to_iso(value, "USDCLP") do
    value
    |> Decimal.round(0)
  end

  def convert_round_to_iso(value, "USDDJF") do
    value
    |> Decimal.round(0)
  end

  def convert_round_to_iso(value, "USDGNF") do
    value
    |> Decimal.round(0)
  end

  def convert_round_to_iso(value, "USDIQD") do
    value
    |> Decimal.round(3)
  end

  def convert_round_to_iso(value, "USDISK") do
    value
    |> Decimal.round(0)
  end

  def convert_round_to_iso(value, "USDJOD") do
    value
    |> Decimal.round(3)
  end

  def convert_round_to_iso(value, "USDJPY") do
    value
    |> Decimal.round(0)
  end

  def convert_round_to_iso(value, "USDKMF") do
    value
    |> Decimal.round(0)
  end

  def convert_round_to_iso(value, "USDKRW") do
    value
    |> Decimal.round(0)
  end

  def convert_round_to_iso(value, "USDKWD") do
    value
    |> Decimal.round(3)
  end

  def convert_round_to_iso(value, "USDLYD") do
    value
    |> Decimal.round(3)
  end

  def convert_round_to_iso(value, "USDOMR") do
    value
    |> Decimal.round(3)
  end

  def convert_round_to_iso(value, "USDPYG") do
    value
    |> Decimal.round(0)
  end

  def convert_round_to_iso(value, "USDRWF") do
    value
    |> Decimal.round(0)
  end

  def convert_round_to_iso(value, "USDTND") do
    value
    |> Decimal.round(3)
  end

  def convert_round_to_iso(value, "USDUGX") do
    value
    |> Decimal.round(0)
  end

  def convert_round_to_iso(value, "USDUYI") do
    value
    |> Decimal.round(0)
  end

  def convert_round_to_iso(value, "USDUYW") do
    value
    |> Decimal.round(4)
  end

  def convert_round_to_iso(value, "USDVND") do
    value
    |> Decimal.round(0)
  end

  def convert_round_to_iso(value, "USDVUV") do
    value
    |> Decimal.round(0)
  end

  def convert_round_to_iso(value, "USDXAF") do
    value
    |> Decimal.round(0)
  end

  def convert_round_to_iso(value, "USDXOF") do
    value
    |> Decimal.round(0)
  end

  def convert_round_to_iso(value, "USDXPF") do
    value
    |> Decimal.round(0)
  end

  def convert_round_to_iso(value, _) do
    value
    |> Decimal.round(2)
  end
end
