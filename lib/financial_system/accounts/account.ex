defmodule FinancialSystem.Accounts.Account do
  use Ecto.Schema

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          currency: String.t(),
          value: integer()
        }

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "accounts" do
    field(:name, :string)
    field(:currency, :string)
    field(:value, :integer)
  end

  def changeset(accounts, params \\ %{}) do
    accounts
    |> Ecto.Changeset.cast(params, [:name, :currency, :value, :id])
    |> Ecto.Changeset.validate_required([:name, :currency, :value])
  end
end
