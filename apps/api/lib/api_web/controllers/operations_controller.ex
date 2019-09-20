defmodule ApiWeb.OperationsController do
  @moduledoc false

  use ApiWeb, :controller

  alias FinancialSystem.Core
  alias ApiWeb.FinancialMiddleware

  action_fallback(ApiWeb.FallbackController)

  def deposit(conn, params) do
    with {:ok, response} <- Core.deposit(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("deposit.json", deposit: response)
    end
  end

  def withdraw(conn, params) do
    with {:ok, response} <- Core.withdraw(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("withdraw.json", withdraw: response)
    end
  end

  def transfer(conn, params) do
    with {:ok, response} <- FinancialMiddleware.make_transfer(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("transfer.json", transfer: response)
    end
  end

  def split(conn, params) do
    with {:ok, response} <- FinancialMiddleware.make_split(params) do
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
        financial_statement: response.transactions,
        account_id: response.account_id
      })
    end
  end

  def show(conn, param) do
    with {:ok, response} <- Core.show(param) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("show.json", %{
        show: response
      })
    end
  end

  def view_all_accounts(conn, _param) do
    with {:ok, response} <- Core.view_all_accounts() do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("view_all_accounts.json", %{
        accounts: response
      })
    end
  end

  def create_contact(conn, params) do
    with {:ok, response} <- Core.create_contact(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("create_contact.json", %{
        create_contact: response
      })
    end
  end

  def get_all_contacts(conn, param) do
    with {:ok, response} <- Core.get_all_contacts(param) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("get_all_contacts.json", %{
        contacts: response
      })
    end
  end

  def update_contact_nickname(conn, params) do
    with {:ok, response} <- Core.update_contact_nickname(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> render("update_contact_nickname.json", %{
        contact: response
      })
    end
  end
end
