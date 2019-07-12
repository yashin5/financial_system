defmodule FinancialSystemWeb.API.Routes.Endpoints.CreateEndpoint do
  def init(param) do
    FinancialSystem.create(
      param["name"],
      param["currency"],
      param["value"]
    )
    |> handle()
  end

  def handle({:ok, response}) do
    %{
      account: response,
      response_status: 201
    }
  end

  def handle({:error, response}), do: %{response_status: 406, msg: response}
end
