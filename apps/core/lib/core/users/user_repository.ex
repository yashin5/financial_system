defmodule FinancialSystem.Core.Users.UserRepository do
  alias FinancialSystem.Core.Repo
  alias FinancialSystem.Core.Tokens.TokenRepository
  alias FinancialSystem.Core.Users.User

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
  def authenticate(email, password) when is_binary(password) do
    with {:ok, user} <- get_user(:auth, email) do
      Argon2.verify_pass(password, user.password_hash)
      |> do_authenticate(user.id)
    end
  end

  def authenticate(_, _), do: {:error, :invalid_password_type}

  defp do_authenticate(true, user_id), do: TokenRepository.generate_token(user_id)

  defp do_authenticate(_, _), do: {:error, :invalid_email_or_password}

  def get_user(:auth, email) do
    User
    |> Repo.get_by(email: email)
    |> do_get_user()
  rescue
    Ecto.Query.CastError -> {:error, :invalid_email_type}
  end

  def get_user(id) do
    User
    |> Repo.get(id)
    |> do_get_user()
  rescue
    Ecto.Query.CastError -> {:error, :invalid_id_type}
  end

  defp do_get_user(nil), do: {:error, :user_dont_exist}

  defp do_get_user(user), do: {:ok, user}
end
