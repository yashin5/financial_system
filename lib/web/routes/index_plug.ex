defmodule Routes.IndexPlug do
  use Plug.Router

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  post "/create" do
    FinancialSystem.create(
      conn.body_params["name"],
      conn.body_params["currency"],
      conn.body_params["value"]
    )
    |> IO.inspect()

    send_resp(conn, 200, "Conta criada com sucesso!")
  end

  delete "/delete" do
    FinancialSystem.delete(conn.body_params["account_id"])
    |> IO.inspect()

    send_resp(conn, 200, "Conta deletada com sucesso!")
  end

  put "/deposit" do
    FinancialSystem.deposit(
      conn.body_params["account_id"],
      conn.body_params["currency"],
      conn.body_params["value"]
    )
    |> IO.inspect()

    send_resp(conn, 200, "Depósito realizado com sucesso!")
  end

  put "/withdraw" do
    FinancialSystem.withdraw(
      conn.body_params["account_id"],
      conn.body_params["value"]
    )
    |> IO.inspect()

    send_resp(conn, 200, "Saque realizado com sucesso!")
  end

  put "/transfer" do
    FinancialSystem.transfer(
      conn.body_params["account_id_from"],
      conn.body_params["account_to_from"],
      conn.body_params["value"]
    )
    |> IO.inspect()

    send_resp(conn, 200, "Transferência realizada com sucesso!")
  end

  put "/split" do
    FinancialSystem.split(
      conn.body_params["account_id_from"],
      conn.body_params["split_list"],
      conn.body_params["value"]
    )
    |> IO.inspect()

    send_resp(conn, 200, "Transferências realizadas com sucesso!")
  end

  put "/financial_statement" do
    FinancialSystem.financial_statement(conn.body_params["account_id"])
    |> IO.inspect()

    send_resp(conn, 200, "Extrato")
  end
end
