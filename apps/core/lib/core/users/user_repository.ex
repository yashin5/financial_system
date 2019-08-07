defmodule FinancialSystem.Core.Users.UserRepository do
  alias FinancialSystem.Core.Users.User
  alias FinancialSystem.Core.Repo

  def new_user(name, email, password) do
    name
    |> new(email, password)
    |> do_new_user()
  end

  defp do_new_user(user) do
    %User{}
    |> User.changeset(user)
    |> Repo.insert()
  end

  defp new(name, email, password) do
    %{name: name, email: email, password: password}
  end

  @callback authenticate(String.t(), String.t()) :: boolean()
  def authenticate(email, password) do
    with {_, user} <- get_user(email) do
      Argon2.verify_pass(password, user.password_hash)
    end
  end

  def get_user(email) do
    User
    |> Repo.get_by(email: email)
    |> do_get_user()
  rescue
    Ecto.Query.CastError -> {:error, :invalid_email_type}
  end

  defp do_get_user(nil), do: {:error, :user_dont_exist}

  defp do_get_user(user), do: {:ok, user}
end
