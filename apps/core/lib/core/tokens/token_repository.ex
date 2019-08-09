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
    token =
       %{token: :crypto.strong_rand_bytes(64)
      |> Base.encode64
      |> binary_part(0, 64)}

    {:ok, token}
  end

  # def get_tokens() do
  #  query = from(u in "tokens",
  #   where: u.account_id == type(^id, :binary_id),
  #   select: [:operation, :value, :inserted_at],
  #   order_by: [{^order, :inserted_at}]
  # )
  # end
end
