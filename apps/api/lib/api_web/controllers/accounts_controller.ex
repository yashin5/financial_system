defmodule ApiWeb.AccountsController do
  use ApiWeb, :controller

  action_fallback(ApiWeb.FallbackController)

  def create(conn, %{
        "name" => name,
        "currency" => currency,
        "value" => value
      }) do
    with {:ok, response} <- FinancialSystem.Core.create(name, currency, value) do
      conn
      |> IO.inspect()
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("create.json", create: response)
    end
  end

  def delete(conn, %{
        "id" => id
      }) do
    with {:ok, response} <- FinancialSystem.Core.delete(id) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("delete.json", delete: response)
    end
  end
end
