defmodule FinancialSystem.Core.Contacts.Contact do
  use Ecto.Schema

  import Ecto.Changeset

  alias FinancialSystem.Core.Accounts.AccountRepository
  alias FinancialSystem.Core.Users.User
  alias FinancialSystem.Core.Users.UserRepository

  @email_regex ~r/@/

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "contacts" do
    field(:nickname, :string)
    field(:email, :string)
    field(:account_id, :string)

    belongs_to(:user, User, type: :binary_id)

    timestamps()
  end

  def changeset(accounts, params \\ %{}) do
    required_fields = [:email, :nickname]

    accounts
    |> cast(params, required_fields)
    |> validate_required(required_fields)
    |> validate_length(:nickname, min: 2, max: 30)
    |> validate_format(:email, @email_regex)
    |> IO.inspect()
    |> get_account_id()
  end

  defp get_account_id(%{valid?: true, changes: %{email: email}} = changeset) do
    with {:ok, user} <- UserRepository.get_user(%{email: email}),
         {:ok, account} <- AccountRepository.find_account(:userid, user.id) do
      change(changeset, %{account_id: account.id})
    end
  end
end
