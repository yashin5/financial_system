defmodule ApiWeb.OperationsController do
    @moduledoc false

  use ApiWeb, :controller

  alias FinancialSystem.Core
  alias FinancialSystem.Core.Split

  action_fallback(ApiWeb.FallbackController)

  def deposit(conn, params) do
    with params_with_account_id <-
           Map.update(params, "account_from", conn.assigns[:account_id], & &1),
         {:ok, response} <- Core.deposit(params_with_account_id) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("deposit.json", deposit: response)
    end
  end

  def withdraw(conn, params) do
    with params_with_account_id <-
           Map.update(params, "account_from", conn.assigns[:account_id], & &1),
         {:ok, response} <- Core.withdraw(params_with_account_id) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("withdraw.json", withdraw: response)
    end
  end

  def transfer(conn, params) do
    with params_with_account_id <-
           Map.update(params, "account_from", conn.assigns[:account_id], & &1),
         {:ok, response} <- Core.transfer(params_with_account_id) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("transfer.json", transfer: response)
    end
  end

  def split(conn, params) do
    with params_with_account_id <-
           Map.update(params, "account_from", conn.assigns[:account_id], & &1),
         {:ok, response} <- Core.split(params_with_account_id) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("split.json", split: response)
    end
  end

  def financial_statement(conn, param) do
    with {:ok, response} <- Core.financial_statement(param) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("financial_statement.json", %{
        financial_statement: response,
        account_id: conn.assigns[:account_id]
      })
    end
  end
end
