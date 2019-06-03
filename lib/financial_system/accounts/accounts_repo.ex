defmodule FinancialSystem.Accounts.AccountsRepo do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: false}

  schema "accounts" do
    field(:name, :string)
    field(:currency, :string)
    field(:value, :integer)
  end

  def changeset(accounts, params \\ %{}) do
    accounts
    |> Ecto.Changeset.cast(params, [:name, :currency, :value, :id])
    |> Ecto.Changeset.validate_required([:name, :currency, :value, :id])
  end
end
