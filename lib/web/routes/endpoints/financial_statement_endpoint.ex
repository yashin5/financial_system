defmodule FinancialSystemWeb.Routes.Endpoints.FinancialStatementEndpoint do
  def init(param) do
    FinancialSystem.financial_statement(param["account_id"])
    |> handle(param["account_id"])
    |> Jason.encode!()
  end

  def handle({:ok, response}, account_id) do
    %{
      account_id: account_id,
      response_status: 201,
      transactions: response
    }
  end

  def handle({:error, response}), do: %{response_status: 406, msg: response}
end
