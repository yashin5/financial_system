defmodule FinancialSystem.Core.Contacts.ContactRepository do
  import Ecto.Query, only: [from: 2]

  alias FinancialSystem.Core.Accounts.AccountRepository
  alias FinancialSystem.Core.Contacts.Contact
  alias FinancialSystem.Core.Repo
  alias FinancialSystem.Core.Users.UserRepository

  @spec create_contact(%{account_id: String.t(), nickname: String.t(), email: String.t()}) ::
          {:ok, Contact.t()} | {:error, atom()}
  def create_contact(%{"account_id" => account_id, "nickname" => nickname, "email" => email}) do
    with {:ok, account} <- AccountRepository.find_account(:accountid, account_id),
         {:ok, user} <- UserRepository.get_user(%{user_id: account.user_id}),
         :ok <-
           already_in_contact(user.id, email),
         {:ok, new_contact} <-
           new_contact(nickname, email) do
      user
      |> Ecto.build_assoc(:contacts, %{})
      |> Contact.changeset(new_contact)
      |> Repo.insert()
    end
  end

  defp new_contact(nickname, email) do
    with {:ok, user} <- UserRepository.get_user(%{email: email}),
         {:ok, account} <- AccountRepository.find_account(:userid, user.id) do
      {:ok, %{nickname: nickname, email: email, account_id: account.id}}
    end
  end

  defp already_in_contact(user_id, email) do
    user_id
    |> get_contacts_emails()
    |> Repo.all()
    |> Enum.member?(email)
    |> do_already_in_contact()
  end

  defp do_already_in_contact(false), do: :ok

  defp do_already_in_contact(true), do: {:error, :already_in_contacts}

  defp get_contacts_emails(user_id) do
    from(u in Contact,
      where: u.user_id == type(^user_id, :binary_id),
      select: u.email
    )
  end

  def get_contact(%{"account_id" => account_id, "email" => email}) do
    with {:ok, account} <- AccountRepository.find_account(:accountid, account_id) do
      account.user_id
      |> get_contacts()
      |> Repo.all()
      |> Enum.filter(fn item -> item.email == email end)
    end
  end

  def get_all_contacts(%{"account_id" => account_id}) do
    with {:ok, account} <- AccountRepository.find_account(:accountid, account_id) do
      account.user_id |> get_contacts() |> Repo.all()
    end
  end

  defp get_contacts(user_id) do
    from(u in Contact,
      where: u.user_id == type(^user_id, :binary_id)
    )
  end
end
