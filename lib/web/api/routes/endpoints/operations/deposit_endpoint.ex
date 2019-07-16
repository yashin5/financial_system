defmodule FinancialSystemWeb.API.Routes.Endpoints.Operations.DepositEndpoint do
  def init(%{req_headers: [{"content-type", "application/json"}]} = param) do
    FinancialSystem.deposit(
      param.body_params["account_id"],
      param.body_params["currency"],
      param.body_params["value"]
    )
    |> handle()
  end

  def init(%{req_headers: _}) do
    %{response_status: 400, msg: :invalid_header}
  end

  def handle({:ok, response}) do
    %{
      account_id: response.id,
      response_status: 201,
      new_balance: response.value
    }
  end

  def handle({:error, response}), do: %{response_status: 406, msg: response}
end
