defmodule ApiWeb.AuthController do
  @moduledoc false

  use ApiWeb, :controller

  alias FinancialSystem.Core

  action_fallback(ApiWeb.FallbackController)

  def validate_token(conn, param) do
    with {:ok, _} <- Core.validate_token(param) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("validate_token.json", validate_token: true)
    end
  end
end
