defmodule ApiWeb.Auth do
  import Plug.Conn

  alias FinancialSystem.Core.Accounts.Account
  alias FinancialSystem.Core.Repo

  def init(options \\ []), do: options

  def call(conn, _options) do
    with token when is_binary(token) <- get_req_header(conn, "authorization") |> List.first(),
         {:ok, user_id} <- FinancialSystem.Core.Tokens.TokenRepository.validate_token(token),
         %Account{} = account <- get_account(user_id) do
      assign(conn, :account_id, account.id)
    else
      _ -> send_resp(conn, 401, Jason.encode!(%{message: "unauthorized"}))
    end
  end

  defp get_account(user_id),
    do: Account |> Repo.get_by(user_id: user_id)
end
