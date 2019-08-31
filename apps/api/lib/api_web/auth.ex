defmodule ApiWeb.Auth do
  import Plug.Conn

  alias FinancialSystem.Core.Accounts.Account
  alias FinancialSystem.Core.Repo
  alias FinancialSystem.Core.Tokens.TokenRepository

  def init(options \\ []), do: options

  def call(conn, _options) do
    with token when is_binary(token) <- conn |> get_req_header("authorization") |> List.first(),
         {:ok, user_id} <- TokenRepository.validate_token(token),
         %Account{} = account <- get_account(user_id) do
      assign(conn, :account_id, account.id)
    else
      _ -> send_resp(conn, 401, Jason.encode!(%{message: "unauthorized"}))
    end
  end

  defp get_account(user_id),
    do: Account |> Repo.get_by(user_id: user_id)
end
