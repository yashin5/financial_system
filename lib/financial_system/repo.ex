defmodule FinancialSystem.Repo do
  use Ecto.Repo,
    otp_app: :financial_system,
    adapter: Ecto.Adapters.Postgres
end
