defmodule FinancialSystemWeb.Routes.AccountsPlug do
  use Plug.Router

  post "/accounts/create" do
    {_, account} =
      FinancialSystem.create(
        conn.body_params["name"],
        conn.body_params["currency"],
        conn.body_params["value"]
      )

    account_json = Jason.encode!(account)

    send_resp(conn, 200, account_json)
  end

  delete "accounts/:id" do
    FinancialSystem.delete(id)

    send_resp(conn, 200, "Conta deletada com sucesso!")
  end
end
