defmodule ApiWeb.AccountsController do
  @moduledoc false

  use ApiWeb, :controller

  alias FinancialSystem.Core

  action_fallback(ApiWeb.FallbackController)

  def authenticate(conn, params) do
    with {:ok, response} <- Core.authenticate(params |> IO.inspect) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("authenticate.json", authenticate: response)
    end
  end

  def create(conn, params) do
    with {:ok, response} <- Core.create(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("create.json", create: response)
    end
  end

  def delete(conn, param) do
    with {:ok, response} <- Core.delete(param) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("delete.json", delete: response)
    end
  end
end
