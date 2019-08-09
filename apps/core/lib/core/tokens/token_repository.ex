defmodule FinancialSystem.Core.Tokens.TokenRepository do
  alias FinancialSystem.Core.Repo
  alias FinancialSystem.Core.Tokens.Token
  alias FinancialSystem.Core.Users.UserRepository


  def generate_token(email) do
    with {:ok, user} <- UserRepository.get_user(email),
    {:ok, new_token} <- new_token() do
      token = Ecto.build_assoc(user, :tokens, new_token)

      token
      |> Token.changeset()
      |> Repo.insert()
    end
  end

  defp new_token do
    length = 2000

    token =
       %{token: :crypto.strong_rand_bytes(length)
      |> Base.encode64
      |> binary_part(0, length)}

    {:ok, token}
  end

  def get_tokens(id) do
    Token
    |> Repo.all(user_id: id)

  end
end
