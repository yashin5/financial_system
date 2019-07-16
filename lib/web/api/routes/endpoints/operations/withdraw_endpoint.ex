defmodule FinancialSystemWeb.API.Routes.Endpoints.Operations.WithdrawEndpoint do
  @spec init(map()) :: %{response_status: 201, account_id: String.t()}
  def init(%{req_headers: [{"content-type", "application/json"}]} = param) do
    FinancialSystem.withdraw(
      param.body_params["account_id"],
      param.body_params["value"]
    )
    |> handle()
  end

  def init(%{req_headers: _}) do
    %{response_status: 400, msg: :invalid_header}
  end

  defp handle({:ok, response}) do
    %{
      account_id: response.id,
      response_status: 201,
      new_balance: response.value
    }
  end

  defp handle({:error, response}), do: %{response_status: 406, msg: response}
end
