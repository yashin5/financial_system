defmodule FinancialSystemWeb.Routes.AccountsPlug do
  use Plug.Router

  post "/accounts/create" do
    {_, create_succsess} =
      FinancialSystem.create(
        conn.body_params["name"],
        conn.body_params["currency"],
        conn.body_params["value"]
      )

    response =
      %{
        account: create_succsess,
        response_status: 200
      }
      |> Jason.encode!()

    send_resp(conn, 200, response)
  end

  delete "accounts/:id" do
    {:ok, delete_succsess} = FinancialSystem.delete(id)
    response = %{msg: delete_succsess, response_status: 200} |> Jason.encode!()

    send_resp(conn, 200, response)
  end
end
