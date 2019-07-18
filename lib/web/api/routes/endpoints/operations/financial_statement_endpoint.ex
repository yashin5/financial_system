defmodule FinancialSystem.Web.API.Routes.Endpoints.Operations.FinancialStatementEndpoint do
  @moduledoc """
  This module is responsable to handle the response and call the financial_statement function.
  """

  alias FinancialSystem.Accounts.Transaction
  alias FinancialSystem.Web.Api.Routes.Endpoints.ErrorResponses

  @spec init(String.t()) ::
          %{
            account_id: String.t(),
            response_status: 200,
            transactions: list(Transaction.t())
          }
          | %{msg: atom(), response_status: pos_integer()}

  def init(id) do
    id
    |> FinancialSystem.financial_statement()
    |> ErrorResponses.handle_error()
    |> handle_response(id)
  end

  defp handle_response({:ok, response}, account_id) do
    %{
      account_id: account_id,
      response_status: 200,
      transactions: response
    }
  end

  defp handle_response(response, _), do: response
end
