defmodule FinancialSystem.Core.Roles.Role do
  use Ecto.Schema

  import Ecto.Changeset

  alias FinancialSystem.Core.Permissions.Permission
  alias FinancialSystem.Core.Users.User

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "tokens" do
    field(:role, :string)

    has_one(:permission, Permission)
    belongs_to(:user, User, type: :binary_id)

    timestamps()
  end

  def changeset_insert(accounts, params \\ %{}) do
    accounts
    |> cast(params, [:role])
    |> validate_required([:role])
  end
end
