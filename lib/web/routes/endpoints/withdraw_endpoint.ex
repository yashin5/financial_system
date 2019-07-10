defmodule FinancialSystemWeb.Routes.Endpoints.WithdrawEndpoint do
  def init(param) do
    FinancialSystem.withdraw(
      param["account_id"],
      param["value"]
    )
    |> handle()
    |> Jason.encode!()
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
