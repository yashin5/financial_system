defmodule FinancialSystem.Core.Contacts.ContactRepository do
  alias FinancialSystem.Core.Repo
  alias FinancialSystem.Core.Contacts.Contact
  alias FinancialSystem.Core.Users.UserRepository

  def create_contact(%{"user_id" => user_id, "nickname" => nickname, "email" => email}) do
    with {:ok, user} <- UserRepository.get_user(%{user_id: user_id}),
         new_contact <- new_contact(nickname, email) do
      user
      |> Ecto.build_assoc(:contacts, new_contact)
      |> Contact.changeset(new_contact)
      |> Repo.insert()
    end
  end

  defp new_contact(nickname, email) do
    %{nickname: nickname, email: email}
  end
end
