defmodule FinancialSystem.Accounts.Transaction do
<<<<<<< HEAD
=======
  @moduledoc """
  Schema to table Transactions
  """
>>>>>>> api/updates
  use Ecto.Schema

  alias FinancialSystem.Accounts.Account

  @type t :: %__MODULE__{
          id: String.t(),
          operation: String.t(),
          value: integer()
        }

<<<<<<< HEAD
=======
  @derive {Jason.Encoder, except: [:__meta__]}

>>>>>>> api/updates
  @primary_key {:id, :binary_id, autogenerate: true}

  schema "transactions" do
    field(:operation, :string)
    field(:value, :integer)
    belongs_to(:account, Account, type: :binary_id)

    timestamps()
  end

  def changeset(accounts, params \\ %{}) do
    accounts
    |> Ecto.Changeset.cast(params, [:id, :operation, :value])
<<<<<<< HEAD
=======
    |> Ecto.Changeset.validate_required([:operation, :value])
    |> Ecto.Changeset.unique_constraint(:id)
>>>>>>> api/updates
  end
end
