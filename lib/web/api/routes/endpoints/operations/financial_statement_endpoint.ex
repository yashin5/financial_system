defmodule FinancialSystem.Web.API.Routes.Endpoints.Operations.FinancialStatementEndpoint do
  alias FinancialSystem.Accounts.Transaction
  alias FinancialSystem.Web.Api.Routes.Endpoints.ErrorResponses

  @spec init(String.t()) ::
          %{
            account_id: String.t(),
            response_status: 200,
            transactions: Transaction.t()
          }
          | %{response_status: 406, msg: String.t()}
  def init(id) do
    FinancialSystem.financial_statement(id)
    |> ErrorResponses.handle_error()
    |> handle_response(id)
  end

  @spec handle_response({:ok, Transaction.t()}, String.t()) ::
          %{
            account_id: String.t(),
            response_status: 200,
            transactions: Transaction.t()
          }
          | %{response_status: 406, msg: String.t()}
  def handle_response({:ok, response}, account_id) do
    %{
      account_id: account_id,
      response_status: 200,
      transactions: response
    }
  end

  def handle_response(response, _), do: response
end
