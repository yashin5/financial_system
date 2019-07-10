defmodule FinancialSystemWeb.Routes.APIPlug do
  use Plug.Router

  alias FinancialSystemWeb.Routes.Endpoints.DepositEndpoint

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  post "/operations/deposit" do
    response = DepositEndpoint.init(conn.body_params)

    send_resp(conn, 200, response)
  end

  post "/operations/withdraw" do
    {:ok, withdraw_succsess} =
      FinancialSystem.withdraw(
        conn.body_params["account_id"],
        conn.body_params["value"]
      )

    response =
      %{
        account_id: withdraw_succsess.id,
        response_status: 200,
        new_balance: withdraw_succsess.value
      }
      |> Jason.encode!()

    send_resp(conn, 200, response)
  end

  put "/operations/transfer" do
    {:ok, transfer_succsess} =
      FinancialSystem.transfer(
        conn.body_params["account_id_from"],
        conn.body_params["account_to_from"],
        conn.body_params["value"]
      )

    response =
      %{
        account_id: transfer_succsess.id,
        response_status: 200,
        new_balance: transfer_succsess.value
      }
      |> Jason.encode!()

    send_resp(conn, 200, response)
  end

  post "/operations/split" do
    {:ok, split_succsess} =
      FinancialSystem.split(
        conn.body_params["account_id_from"],
        conn.body_params["split_list"],
        conn.body_params["value"]
      )

    response =
      %{
        account_id: split_succsess.id,
        response_status: 200,
        new_balance: split_succsess.value
      }
      |> Jason.encode!()

    send_resp(conn, 200, response)
  end

  get "/operations/financial_statement" do
    with {:ok, statement} = FinancialSystem.financial_statement(conn.query_params["account_id"]),
         {:ok, response} <- Jason.encode(statement) do
      send_resp(conn, 200, response)
    end
  end
end
