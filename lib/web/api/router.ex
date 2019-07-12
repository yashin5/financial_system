defmodule FinancialSystemWeb.API.Router do
  use Plug.Router

  alias FinancialSystemWeb.API.Routes.Endpoints.{
    CreateEndpoint,
    DeleteEndpoint,
    DepositEndpoint,
    FinancialStatementEndpoint,
    SplitEndpoint,
    TransferEndpoint,
    WithdrawEndpoint
  }

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["application/json", "application/x-www-form-urlencoded"],
    json_decoder: Jason
  )

  plug(:dispatch)

  post "/accounts" do
    response = CreateEndpoint.init(conn.body_params)

    send_resp(conn, response.response_status, Jason.encode!(response))
  end

  delete "/accounts/:id" do
    response = DeleteEndpoint.init(id)

    send_resp(conn, 200, response)
  end

  post "/operations/deposit" do
    response = DepositEndpoint.init(conn.body_params)

    send_resp(conn, 200, response)
  end

  post "/operations/withdraw" do
    response = WithdrawEndpoint.init(conn.body_params)

    send_resp(conn, response.response_status, Jason.encode!(response))
  end

  post "/operations/transfer" do
    response = TransferEndpoint.init(conn.body_params)

    send_resp(conn, response.response_status, Jason.encode!(response))
  end

  post "/operations/split" do
    response = SplitEndpoint.init(conn.body_params)

    send_resp(conn, response.response_status, Jason.encode!(response))
  end

  get "/operations/financial_statement" do
    response = FinancialStatementEndpoint.init(conn.body_params)

    send_resp(conn, response.response_status, Jason.encode!(response))
  end
end
