defmodule FinancialSystem.Web.API.Routes.Endpoints.Operations.SplitEndpoint do
  alias FinancialSystem.Web.Api.Routes.Endpoints.ErrorResponses

  @spec init(map) ::
          %{response_status: 201, account_id: String.t(), new_balance: pos_integer()}
          | %{msg: atom(), response_status: pos_integer()}


  def init(%{req_headers: [{"content-type", "application/json"}]} = param) do
    split_list =
      Enum.map(param.body_params["split_list"], fn item ->
        %FinancialSystem.Split{account: item["account"], percent: item["percent"]}
      end)

    FinancialSystem.split(
      param.body_params["account_id_from"],
      split_list,
      param.body_params["value"]
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
