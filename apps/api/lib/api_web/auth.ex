defmodule ApiWeb.Auth do
  import Plug.Conn

  def init(options \\ []), do: options

  def call(conn, _options) do
    with token when is_binary(token) <- get_req_header(conn, "authorization") |> List.first(),
         {:ok, _token} <- FinancialSystem.Core.Tokens.TokenRepository.validate_token(token) do
      conn
    else
      _ -> send_resp(conn, 401, Jason.encode!(%{message: "unauthorized"}))
    end
  end
end
