defmodule FinancialSystem.Core.Roles.Role do
  @moduledoc """
    Schema to table Role
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias FinancialSystem.Core.Permissions.Permission

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "roles" do
    field(:role, :string)

    has_one(:permission, Permission)

    timestamps()
  end

  def changeset(accounts, params \\ %{}) do
    accounts
    |> cast(params, [:role])
    |> validate_required([:role])
  end
end
