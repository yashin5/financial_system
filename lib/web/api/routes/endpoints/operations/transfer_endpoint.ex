defmodule FinancialSystem.Web.API.Routes.Endpoints.Operations.TransferEndpoint do
  @moduledoc """
  This module is responsable to handle the response and call the transfer function.
  """

  alias FinancialSystem.Web.Api.Routes.Endpoints.ErrorResponses

  @spec init(map) ::
          %{response_status: 201, account_id: String.t(), new_balance: pos_integer()}
          | %{msg: atom(), response_status: pos_integer()}

  def init(%{req_headers: [{"content-type", "application/json"}]} = param) do
    param.body_params["value"]
    |> FinancialSystem.transfer(
      param.body_params["account_from"],
      param.body_params["account_to"]
    )
    |> ErrorResponses.handle_error()
    |> handle_response()
  end

  def init(%{req_headers: _}) do
    %{response_status: 400, msg: :invalid_header}
  end

  defp handle_response({:ok, response}) do
    %{
      account_id: response.id,
      response_status: 201,
      new_balance: response.value
    }
  end

  defp handle_response(response), do: response
end