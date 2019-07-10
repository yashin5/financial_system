defmodule FinancialSystemWeb.Routes.Endpoints.DepositEndpoint do
  def init(param) do
    FinancialSystem.deposit(
      param["account_id"],
      param["currency"],
      param["value"]
    )
    |> handle()
    |> Jason.encode!()
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
