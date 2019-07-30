defmodule ApiWeb.AccountsController do
  use ApiWeb, :controller

  def create(conn, params) do
    {_, response} =
      params["name"] |> FinancialSystem.Core.create(params["currency"], params["value"])

    render(conn, "create.json", account: response)
  end
end
