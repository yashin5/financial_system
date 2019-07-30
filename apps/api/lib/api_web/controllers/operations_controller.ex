defmodule ApiWeb.OperationsController do
  use ApiWeb, :controller

  def deposit(conn, params) do
    {_, response} =
      FinancialSystem.Core.deposit(params["account_id"], params["currency"], params["value"])

    render(conn, "deposit.json", deposit: response)
  end
end
