defmodule FinancialSystem.Web.API.Routes.Endpoints.Accounts.CreateEndpoint do
  alias FinancialSystem.Web.Api.Routes.Endpoints.ErrorResponses

  def init(%{req_headers: [{"content-type", "application/json"}]} = param) do
    FinancialSystem.create(
      param.body_params["name"],
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
      account: response,
      response_status: 201
    }
  end

  def handle_response(response), do: response
end
