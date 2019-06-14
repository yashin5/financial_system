defmodule AppRouter do
  use Plug.Router

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  post "/hello" do
    # Prints JSON POST body
    IO.inspect(conn.body_params)
    send_resp(conn, 200, "Success!")
  end
end
