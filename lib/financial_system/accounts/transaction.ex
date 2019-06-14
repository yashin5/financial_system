defmodule FinancialSystem.Accounts.Transaction do
  @moduledoc """
  Schema to table Transactions
  """
  use Ecto.Schema

  alias FinancialSystem.Accounts.Account

  @type t :: %__MODULE__{
          id: String.t(),
          operation: String.t(),
          value: integer()
        }

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
  end
end
