defmodule FinancialSystem.Core.Accounts.Account do
  @moduledoc """
  Schema to table Accounts
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias FinancialSystem.Core.Accounts.Transaction
  alias FinancialSystem.Core.Users.User

  @type t :: %__MODULE__{
          id: String.t(),
          currency: String.t(),
          value: integer()
        }

  @derive {Jason.Encoder, only: [:id, :currency, :value]}

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "accounts" do
    field(:active, :boolean)
    field(:currency, :string)
    field(:value, :integer)

    belongs_to(:user, User, type: :binary_id)
    has_many(:transactions, Transaction, foreign_key: :account_id)

    timestamps()
  end

  def changeset(accounts, params \\ %{}) do
    accounts
    |> cast(params, [:active, :currency, :value, :id])
    |> validate_required([:currency, :value])
    |> unique_constraint(:id)
  end
end
