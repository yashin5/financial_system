defmodule FinancialSystem.Accounts.AccountsRepo do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "account" do
    field(:name, :string)
    field(:currency, :string)
    field(:balance, :integer)
  end
end
