defmodule FinancialSystem.Core.Tokens.TokenRepository do
  alias FinancialSystem.Core.Repo
  alias FinancialSystem.Core.Tokens.Token
  alias FinancialSystem.Core.Users.UserRepository

  def generate_token(id) do
    with {:ok, user} <- UserRepository.get_user(id),
         {:ok, new_token} <- new_token() do
      {_, token} =
        user
        |> Ecto.build_assoc(:tokens, new_token)
        |> Token.changeset_insert()
        |> Repo.insert()

      {:ok, token.token}
    end
  end

  defp new_token do
    length = 64

    token = %{
      token:
        :crypto.strong_rand_bytes(length)
        |> Base.encode64()
        |> binary_part(0, length)
    }

    {:ok, token}
  end

  def get_last_token_generated(id) do
    Token
    |> Repo.all(user_id: id)
    |> List.last()
    |> validate_token()
  end

  defp validate_token(%Token{} = token) do
    {date, time} = :calendar.local_time()
    {year, month, day} = date
    {hour, min, sec} = time
    {_, time_now} = NaiveDateTime.new(year, month, day, hour + 3, min, sec)

    season_duration = 15

    time_now
    |> NaiveDateTime.diff(token.updated_at)
    |> Kernel.<=(season_duration)
    |> do_validate_token(token, time_now)
  end

  defp do_validate_token(true, token, time_now) do
    token
    |> Token.changeset_update(%{updated_at: time_now})
    |> Repo.update()
  end

  defp do_validate_token(false, _, _), do: {:error, :season_expired}
end
