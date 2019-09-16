defmodule FinancialSystem.Core.Permissions.Permission do
  use Ecto.Schema

  import Ecto.Changeset

  alias FinancialSystem.Core.Roles.Role

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "permissions" do
    field(:can_view, :boolean)
    field(:can_create, :boolean)
    field(:can_delete, :boolean)
    field(:can_view_all, :boolean)

    belongs_to(:role, Role, type: :binary_id)

    timestamps()
  end

  def changeset(accounts, params \\ %{}) do
    accounts
    |> cast(params, [:can_view, :can_create, :can_delete, :can_view_all])
    |> validate_required([:can_view, :can_create, :can_delete, :can_view_all])
  end
end
