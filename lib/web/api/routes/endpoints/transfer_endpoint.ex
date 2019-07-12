defmodule FinancialSystemWeb.API.Routes.Endpoints.TransferEndpoint do
  def init(param) do
    FinancialSystem.transfer(
      param["value"],
      param["account_from"],
      param["account_to"]
    )
    |> handle()
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
