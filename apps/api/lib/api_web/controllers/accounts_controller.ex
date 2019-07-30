defmodule ApiWeb.AccountsController do
  use ApiWeb, :controller

  def create(conn, params) do
    {_, response} =
      params["name"] |> FinancialSystem.Core.create(params["currency"], params["value"])

    render(conn, "create.json", create: response)
  end

  def delete(conn, params) do
    {_, response} = FinancialSystem.Core.delete(params["id"])

    render(conn, "delete.json", delete: response)
  end
end
