defmodule FinancialSystem.Core.Users.User do
  @moduledoc """
  Schema to table User
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias FinancialSystem.Core.Accounts.Account
  alias FinancialSystem.Core.Contacts.Contact
  alias FinancialSystem.Core.Tokens.Token

  @type t :: %__MODULE__{
          email: String.t(),
          name: String.t(),
          password_hash: String.t()
        }

  @email_regex ~r/@/
  @password_regex ~r/^.*(?=.{8,})((?=.*[!@#$%^&*()\-_=+{};:,<.>]){1})(?=.*\d)((?=.*[a-z]){1})((?=.*[A-Z]){1}).*$/

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field(:role, :string)
    field(:email, :string)
    field(:name, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)

    has_one(:account, Account)
    has_many(:tokens, Token)
    has_many(:contacts, Contact)

    timestamps()
  end

  def changeset(accounts, params \\ %{}) do
    required_fields = [:role, :name, :email, :password]

    accounts
    |> cast(params, required_fields)
    |> validate_required(required_fields)
    |> validate_length(:name, min: 2, max: 30)
    |> validate_length(:password, min: 6, max: 150)
    |> validate_length(:role, min: 5, max: 7)
    |> validate_format(:email, @email_regex)
    |> validate_pass()
    |> put_hash()
    |> unique_constraint(:email)
  end

  defp validate_pass(%{valid?: true, changes: %{password: pass}} = changeset) do
    @password_regex
    |> Regex.match?(pass)
    |> do_validate_pass(changeset)
  end

  defp validate_pass(changeset), do: changeset

  defp do_validate_pass(true, changeset), do: changeset

  defp do_validate_pass(_, changeset) do
    add_error(changeset, :password, "Password does not match the minimun requirements")
  end

  defp put_hash(%{valid?: true, changes: %{password: pass}} = changeset) do
    change(changeset, %{password_hash: Argon2.hash_pwd_salt(pass), password: nil})
  end

  defp put_hash(changeset), do: changeset
end
