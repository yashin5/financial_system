defmodule FinancialSystem.Web.API.Routes.Endpoints.Accounts.DeleteEndpoint do
  alias FinancialSystem.Web.Api.Routes.Endpoints.ErrorResponses

  def init(param) do
    FinancialSystem.delete(param)
    |> ErrorResponses.handle_error()
    |> handle_response()
  end

  def handle_response({:ok, response}) do
    %{
      msg: response,
      response_status: 201
    }
  end

  def handle_response(response), do: response
end
