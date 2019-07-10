defmodule FinancialSystemWeb.Routes.Endpoints.DeleteEndpoint do
  def init(param) do
    FinancialSystem.delete(param)
    |> handle()
    |> Jason.encode!()
  end

  def handle({:ok, response}) do
    %{
      msg: response,
      response_status: 201
    }
  end

  def handle({:error, response}), do: %{response_status: 406, msg: response}
end
