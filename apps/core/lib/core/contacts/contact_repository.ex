defmodule FinancialSystem.Core.Contacts.ContactRepository do
  import Ecto.Query, only: [from: 2]

  alias FinancialSystem.Core.Accounts.AccountRepository
  alias FinancialSystem.Core.Contacts.Contact
  alias FinancialSystem.Core.Repo
  alias FinancialSystem.Core.Users.UserRepository

  @callback create_contact(%{account_id: String.t(), nickname: String.t(), email: String.t()}) ::
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

  @callback get_all_contacts(%{account_id: String.t()}) ::
              {:ok, list(Contact.t())} | {:error, atom()}
  def get_all_contacts(%{"account_id" => account_id}) do
    with {:ok, account} <- AccountRepository.find_account(:accountid, account_id) do
      {:ok, account.user_id |> get_contacts() |> Repo.all()}
    end
  end

  defp get_contacts(user_id) do
    from(u in Contact,
      where: u.user_id == type(^user_id, :binary_id)
    )
  end

  def update_contact_nickname(%{
        "account_id" => account_id,
        "new_nickname" => nickname,
        "email" => email
      }) do
    with {:ok, account} <- AccountRepository.find_account(:accountid, account_id),
         contact <- get_contact_by_email(account.user_id, email),
         %Contact{} = contact_verified <- verify_actual_nickname(contact, nickname) do
      contact_actualized =
        contact_verified
        |> Contact.changeset_update(%{nickname: nickname})
        |> Repo.update()

      contact_actualized
    end
  end

  defp verify_actual_nickname(%Contact{} = contact, new_nickname) do
    contact.nickname
    |> Kernel.==(new_nickname)
    |> do_verify_actual_nickname(contact)
  end

  defp verify_actual_nickname(nil, _), do: {:error, :user_dont_exist}

  defp do_verify_actual_nickname(false, contact), do: contact

  defp do_verify_actual_nickname(true, _), do: {:error, :contact_actual_name}

  def get_contact_by_email(user_id, email) do
    user_id |> get_contacts() |> Repo.get_by(email: email)
  end
end
