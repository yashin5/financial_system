defmodule ApiWeb.AccountsController do
  use ApiWeb, :controller

  def create(conn, %{"name" => name, "currency" => currency, "value" => value}) do
    with {:ok, response} <- FinancialSystem.Core.create(name, currency, value) do
      conn
      |> put_status(:created)
      |> render("create.json", create: response)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, response} <- FinancialSystem.Core.delete(id) do
      conn
      |> put_status(:created)
      |> render("delete.json", delete: response)
    end
  end
end
