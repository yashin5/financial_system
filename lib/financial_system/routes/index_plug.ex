defmodule FinancialSystem.Routes.IndexPlug do
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

    send_resp(conn, 200, "Success!")
  end
end
