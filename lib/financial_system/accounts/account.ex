defmodule FinancialSystem.Accounts.Account do
  use Ecto.Schema

  alias FinancialSystem.Accounts.Transaction

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
    has_many(:transactions, Transaction, foreign_key: :account_id)

    timestamps()
  end

  def changeset(accounts, params \\ %{}) do
    accounts
    |> Ecto.Changeset.cast(params, [:name, :currency, :value, :id])
    |> Ecto.Changeset.validate_required([:name, :currency, :value])
    |> Ecto.Changeset.unique_constraint(:id)
  end
end
