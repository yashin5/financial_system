defmodule FinancialSystem.Web.API.Routes.Endpoints.Operations.DepositEndpoint do
  alias FinancialSystem.Web.Api.Routes.Endpoints.ErrorResponses

  def init(%{req_headers: [{"content-type", "application/json"}]} = param) do
    FinancialSystem.deposit(
      param.body_params["account_id"],
      param.body_params["currency"],
      param.body_params["value"]
    )
    |> ErrorResponses.handle_error()
    |> handle_response()
  end

  def init(%{req_headers: _}) do
    %{response_status: 400, msg: :invalid_header}
  end

  def handle_response({:ok, response}) do
    %{
      account_id: response.id,
      response_status: 201,
      new_balance: response.value
    }
  end

  def handle_response(response), do: response
end
