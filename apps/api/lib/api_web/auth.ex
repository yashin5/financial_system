defmodule ApiWeb.Auth do
  @moduledoc """
  This module is a Plug responsable to make the authorization in a router pipeline.
  """

  import Plug.Conn

  alias FinancialSystem.Core.Accounts.Account
  alias FinancialSystem.Core.Accounts.AccountRepository
  alias FinancialSystem.Core.Tokens.TokenRepository
  alias FinancialSystem.Core.Users.UserRepository

  def init(options \\ []), do: options

  def call(conn, _options) do
    with token when is_binary(token) <- conn |> get_req_header("authorization") |> List.first(),
         {:ok, user_id} <- TokenRepository.validate_token(token),
         {:ok, user} <- UserRepository.get_user(user_id),
         {:ok, %Account{} = account} <- AccountRepository.find_account(:userid, user_id) do
      assign(conn, :account_id, account.id) |> assign(:role, user.role)
    else
      _ -> send_resp(conn, 401, Jason.encode!(%{message: "unauthorized"}))
    end
  end
end
