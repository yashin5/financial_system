defmodule FinancialSystem.Core.Users.User do
  use Ecto.Schema

  alias FinancialSystem.Core.Accounts.Account

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)
    has_one(:account, Account, foreign_key: :user_id)

    timestamps()
  end

  def changeset(accounts, params \\ %{}) do
    accounts
    |> Ecto.Changeset.cast(params, [:email, :password])
    |> Ecto.Changeset.unique_constraint(:id)
  end
end
