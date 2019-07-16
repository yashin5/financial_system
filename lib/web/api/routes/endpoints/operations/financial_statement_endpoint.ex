defmodule FinancialSystemWeb.API.Routes.Endpoints.Operations.FinancialStatementEndpoint do
  alias FinancialSystem.Accounts.Transaction

  @spec init(String.t()) ::
          %{
            account_id: String.t(),
            response_status: 200,
            transactions: Transaction.t()
          }
          | %{response_status: 406, msg: String.t()}
  def init(id) do
    FinancialSystem.financial_statement(id)
    |> handle(id)
  end

  @spec handle({:ok, Transaction.t()}, String.t()) ::
          %{
            account_id: String.t(),
            response_status: 200,
            transactions: Transaction.t()
          }
          | %{response_status: 406, msg: String.t()}
  def handle({:ok, response}, account_id) do
    %{
      account_id: account_id,
      response_status: 200,
      transactions: response
    }
  end

  def handle({:error, response}, _), do: %{response_status: 406, msg: response}
end
