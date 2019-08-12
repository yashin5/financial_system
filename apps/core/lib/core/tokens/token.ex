defmodule FinancialSystem.Core.Tokens.Token do
  @moduledoc """
  Schema to table Accounts
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias FinancialSystem.Core.Users.User

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "tokens" do
    field(:token, :string)

    belongs_to(:user, User, type: :binary_id)

    timestamps()
  end

  def changeset_insert(accounts, params \\ %{}) do
    accounts
    |> cast(params, [:token, :user_id])
    |> validate_required([:token, :user_id])
    |> unique_constraint(:id)
  end

  def changeset_update(accounts, params \\ %{}) do
    accounts
    |> cast(params, [:updated_at])
    |> validate_required([:updated_at])
    |> unique_constraint(:id)
  end
end
