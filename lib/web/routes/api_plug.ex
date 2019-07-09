defmodule FinancialSystemWeb.Routes.APIPlug do
  use Plug.Router

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  post "/accounts" do
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

  post "/operations/deposit" do
    FinancialSystem.deposit(
      conn.body_params["account_id"],
      conn.body_params["currency"],
      conn.body_params["value"]
    )

    send_resp(conn, 200, "Depósito realizado com sucesso!")
  end

  post "/operations/withdraw" do
    FinancialSystem.withdraw(
      conn.body_params["account_id"],
      conn.body_params["value"]
    )

    send_resp(conn, 200, "Saque realizado com sucesso!")
  end

  put "/operations/transfer" do
    FinancialSystem.transfer(
      conn.body_params["account_id_from"],
      conn.body_params["account_to_from"],
      conn.body_params["value"]
    )

    send_resp(conn, 200, "Transferência realizada com sucesso!")
  end

  put "/operations/split" do
    FinancialSystem.split(
      conn.body_params["account_id_from"],
      conn.body_params["split_list"],
      conn.body_params["value"]
    )

    send_resp(conn, 200, "Transferências realizadas com sucesso!")
  end

  get "/operations/financial_statement" do
    with {:ok, statement} = FinancialSystem.financial_statement(conn.query_params["account_id"]),
         {:ok, response} <- Jason.encode(statement) do
      send_resp(conn, 200, response)
    end
  end
end
