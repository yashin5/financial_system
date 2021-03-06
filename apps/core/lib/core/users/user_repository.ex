defmodule FinancialSystem.Core.Users.UserRepository do
  @moduledoc """
    This module is responsable to create, get and authenticate a user.
  """

  alias FinancialSystem.Core.Repo
  alias FinancialSystem.Core.Tokens.TokenRepository
  alias FinancialSystem.Core.Users.User

  @doc """
  Create a user

  ## Examples
      FinancialSystem.Core.Users.UserRepository.new_user("Yashin Santos",  "y@gmail.com", "B@kxin123")
  """
  @spec new_user(String.t(), String.t(), String.t(), String.t()) ::
          {:ok, User.t()} | {:error, atom()}
  def new_user(role, name, email, password) when role in ["regular"] do
    role
    |> new(name, email, password)
    |> do_new_user()
  end

  defp do_new_user(user) do
    %User{}
    |> User.changeset(user)
    |> Repo.insert()
  end

  defp new(role, name, email, password) do
    %{role: role, name: name, email: email, password: password}
  end

  @doc """
  Verify if email and password is valid

  ## Examples
      {:ok, account} = FinancialSystem.Core.create(
        %{
          "name" => "Yashin Santos",
          "currency" => "EUR",
          "value" => "220",
          "email" => "xx@xx.com",
          "password" => "B@xopn123"
        })

      FinancialSystem.Core.Users.UserRepository.authenticate(y@gmin.com", "B@kxin123")
  """
  @callback authenticate(%{email: String.t(), password: String.t()}) ::
              {:ok, String.t()} | {:error, atom()}
  def authenticate(%{
        "email" => email,
        "password" => password
      })
      when is_binary(password) do
    with {:ok, user} <- get_user(%{email: email}) do
      password
      |> Argon2.verify_pass(user.password_hash)
      |> do_authenticate(user.id)
    end
  end

  def authenticate(_), do: {:error, :invalid_password_type}

  defp do_authenticate(true, user_id), do: TokenRepository.generate_token(user_id)

  defp do_authenticate(_, _), do: {:error, :invalid_email_or_password}

  @spec get_user(none() | %{email: String.t()} | %{user_id: String.t()}) ::
          {:ok, User.t()} | {:error, atom()}
  def get_user(%{email: email}) do
    User
    |> Repo.get_by(email: email)
    |> do_get_user()
  rescue
    Ecto.Query.CastError -> {:error, :invalid_email_type}
  end

  def get_user(%{user_id: account_id}) do
    User
    |> Repo.get(account_id)
    |> do_get_user()
  rescue
    Ecto.Query.CastError -> {:error, :invalid_id_type}
  end

  defp do_get_user(nil), do: {:error, :user_dont_exist}

  defp do_get_user(user), do: {:ok, user}
end
