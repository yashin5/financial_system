defmodule ApiWeb.OperationsController do
  use ApiWeb, :controller

  alias FinancialSystem.Core
  alias FinancialSystem.Core.Split

  action_fallback(ApiWeb.FallbackController)

  def deposit(conn, %{
        "account_id" => account_id,
        "currency" => currency,
        "value" => value
      }) do
    with {:ok, response} <- Core.deposit(account_id, currency, value) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("deposit.json", deposit: response)
    end
  end

  def withdraw(conn, %{
        "account_id" => account_id,
        "value" => value
      }) do
    with %{req_headers: [{"content-type", "application/json"}]} <- conn,
         {:ok, response} <- Core.withdraw(account_id, value) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("withdraw.json", withdraw: response)
    end
  end

  def transfer(conn, %{
        "value" => value,
        "account_from" => account_id_from,
        "account_to" => account_id_to
      }) do
    with {:ok, response} <- Core.transfer(value, account_id_from, account_id_to) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("transfer.json", transfer: response)
    end
  end

  def split(conn, %{
        "account_id_from" => account_id_from,
        "split_list" => split_list_param,
        "value" => value
      }) do
    with split_list <-
           Enum.map(split_list_param, fn item ->
             %Split{account: item["account"], percent: item["percent"]}
           end),
         {:ok, response} <- Core.split(account_id_from, split_list, value) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("split.json", split: response)
    end
  end

  def financial_statement(conn, %{"id" => id}) do
    with {:ok, response} <- Core.financial_statement(id) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("financial_statement.json", %{financial_statement: response, account_id: id})
    end
  end
end
