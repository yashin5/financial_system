defmodule FinancialSystem.Core.Authorizations.Authorization do
  use Ecto.Schema

  import Ecto.Changeset

  alias FinancialSystem.Core.Users.User

  @type t :: %__MODULE__{
          id: String.t()
        }

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "tokens" do
    field(:role, :string)
    field(:permissions, {:array, :inner_type})

    belongs_to(:user, User, type: :binary_id)

    timestamps()
  end

  def changeset_insert(accounts, params \\ %{}) do
    accounts
    |> cast(params, [:role, :permissions])
    |> validate_required([:role, :permissions])
  end
end
