defmodule FinancialSystemWeb.Routes.Endpoints.SplitEndpoint do
  def init(param) do
    FinancialSystem.split(
      param["account_id_from"],
      param["split_list"],
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
