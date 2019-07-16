defmodule FinancialSystemWeb.API.Routes.Endpoints.Accounts.DeleteEndpoint do
  def init(param) do
    FinancialSystem.delete(param)
    |> handle()
  end

  def handle({:ok, response}) do
    %{
      msg: response,
      response_status: 201
    }
  end

  def handle({:error, response}), do: %{response_status: 406, msg: response}
end
