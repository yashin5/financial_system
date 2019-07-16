defmodule FinancialSystem.Accounts.Account do
<<<<<<< HEAD
=======
  @moduledoc """
  Schema to table Accounts
  """
>>>>>>> api/updates
  use Ecto.Schema

  alias FinancialSystem.Accounts.Transaction

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          currency: String.t(),
          value: integer()
        }

<<<<<<< HEAD
  @primary_key {:id, :binary_id, autogenerate: true}

  schema "accounts" do
=======
  @derive {Jason.Encoder, only: [:id, :name, :currency, :value]}

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "accounts" do
    field(:active, :boolean)
>>>>>>> api/updates
    field(:name, :string)
    field(:currency, :string)
    field(:value, :integer)
    has_many(:transactions, Transaction, foreign_key: :account_id)

    timestamps()
  end

  def changeset(accounts, params \\ %{}) do
    accounts
<<<<<<< HEAD
    |> Ecto.Changeset.cast(params, [:name, :currency, :value, :id])
=======
    |> Ecto.Changeset.cast(params, [:active, :name, :currency, :value, :id])
>>>>>>> api/updates
    |> Ecto.Changeset.validate_required([:name, :currency, :value])
    |> Ecto.Changeset.unique_constraint(:id)
  end
end
