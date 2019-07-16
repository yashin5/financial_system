defmodule FinancialSystemWeb.API.Routes.Endpoints.Operations.SplitEndpoint do
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
    |> handle()
  end

  def init(%{req_headers: _}) do
    %{response_status: 400, msg: :invalid_header}
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
