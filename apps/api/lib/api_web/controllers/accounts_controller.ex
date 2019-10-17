defmodule ApiWeb.AccountsController do
  @moduledoc false

  use ApiWeb, :controller

  alias FinancialSystem.Core

  action_fallback(ApiWeb.FallbackController)

  def authenticate(conn, params) do
    with {:ok, response} <- Core.authenticate(params) do
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

  def get_currencies(conn, _param) do
    with response <- Core.get_currencies() do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("get_currencies.json", currencies: response)
    end
  end
end
