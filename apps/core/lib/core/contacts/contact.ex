defmodule FinancialSystem.Core.Contacts.Contact do
  @moduledoc """
    Schema to table Contact
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias FinancialSystem.Core.Users.User

  @type t :: %__MODULE__{
          nickname: String.t(),
          account_id: String.t(),
          email: String.t()
        }

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "contacts" do
    field(:nickname, :string)
    field(:account_id, :binary_id)
    field(:email, :string)

    belongs_to(:user, User, type: :binary_id)

    timestamps()
  end

  def changeset(contacts, params \\ %{}) do
    contacts
    |> cast(params, [:nickname, :email, :user_id, :account_id])
    |> validate_required([:nickname, :email, :user_id, :account_id])
    |> unique_constraint(:id)
  end

  def changeset_update(accounts, params \\ %{}) do
    accounts
    |> cast(params, [:nickname])
    |> validate_required([:nickname])
    |> unique_constraint(:id)
  end
end
