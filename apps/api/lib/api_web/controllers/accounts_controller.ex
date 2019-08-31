defmodule ApiWeb.AccountsController do
  @moduledoc false

  use ApiWeb, :controller

  alias FinancialSystem.Core

  action_fallback(ApiWeb.FallbackController)

  def authenticate(conn, %{
        "email" => email,
        "password" => password
      }) do
    with {:ok, response} <- Core.authenticate(email, password) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("authenticate.json", authenticate: response)
    end
  end

  def create(conn, %{
        "name" => name,
        "currency" => currency,
        "value" => value,
        "email" => email,
        "password" => password
      }) do
    with {:ok, response} <- Core.create(name, currency, value, email, password) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("create.json", create: response)
    end
  end

  def delete(conn, %{
        "id" => id
      }) do
    with {:ok, response} <- Core.delete(id) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("delete.json", delete: response)
    end
  end
end
