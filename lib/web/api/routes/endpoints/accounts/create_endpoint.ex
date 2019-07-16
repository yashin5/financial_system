defmodule FinancialSystemWeb.API.Routes.Endpoints.Accounts.CreateEndpoint do
  def init(%{req_headers: [{"content-type", "application/json"}]} = param) do
    FinancialSystem.create(
      param.body_params["name"],
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
      account: response,
      response_status: 201
    }
  end

  def handle({:error, response}), do: %{response_status: 406, msg: response}
end
