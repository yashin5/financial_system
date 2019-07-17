defmodule FinancialSystem.Web.API.Routes.Endpoints.Accounts.DeleteEndpoint do
  alias FinancialSystem.Web.Api.Routes.Endpoints.ErrorResponses

  @spec init(String.t()) :: %{msg: atom(), response_status: pos_integer}
  def init(param) do
    param
    |> FinancialSystem.delete()
    |> ErrorResponses.handle_error()
    |> handle_response()
  end

  defp handle_response({:ok, response}) do
    %{
      msg: response,
      response_status: 201
    }
  end

  defp handle_response(response), do: response
end
