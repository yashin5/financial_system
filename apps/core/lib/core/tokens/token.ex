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

  def changeset(accounts, params \\ %{}) do
    accounts
    |> cast(params, [:token, :user_id])
    |> unique_constraint(:id)
  end
end
