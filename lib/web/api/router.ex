defmodule FinancialSystem.Web.API.Router do
  use Plug.Router

  alias FinancialSystem.Web.API.Routes.Endpoints.Accounts.{CreateEndpoint, DeleteEndpoint}

  alias FinancialSystem.Web.API.Routes.Endpoints.Operations.{
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
    response = CreateEndpoint.init(conn)

    send_resp(conn, response.response_status, Jason.encode!(response))
  end

  delete "/accounts/:id" do
    response = DeleteEndpoint.init(id)

    send_resp(conn, response.response_status, Jason.encode!(response))
  end

  post "/operations/deposit" do
    response = DepositEndpoint.init(conn)

    send_resp(conn, response.response_status, Jason.encode!(response))
  end

  post "/operations/withdraw" do
    response = WithdrawEndpoint.init(conn)

    send_resp(conn, response.response_status, Jason.encode!(response))
  end

  post "/operations/transfer" do
    response = TransferEndpoint.init(conn)

    send_resp(conn, response.response_status, Jason.encode!(response))
  end

  post "/operations/split" do
    response = SplitEndpoint.init(conn)

    send_resp(conn, response.response_status, Jason.encode!(response))
  end

  get "/operations/financial_statement/:id" do
    response = FinancialStatementEndpoint.init(id)

    send_resp(conn, response.response_status, Jason.encode!(response))
  end
end
