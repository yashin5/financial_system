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
         {:ok, user} <- UserRepository.get_user(%{user_id: user_id}),
         {:ok, %Account{} = account} <-
           AccountRepository.find_account(:userid, user_id),
         params_with_account_id <-
           Map.put(conn, :params, Map.merge(conn.params, %{"account_id" => account.id})) do
      assign(params_with_account_id, :role, user.role)
    else
      _ ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(401, Jason.encode!(%{message: "unauthorized"}))
        |> halt()
    end
  end
end
