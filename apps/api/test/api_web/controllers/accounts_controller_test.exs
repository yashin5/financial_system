defmodule ApiWeb.AccountsControllerTest do
  use ApiWeb.ConnCase

  import Mox

  alias FinancialSystem.Core

  setup :verify_on_exit!

  describe "POST /api/accounts" do
    test "POST /", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      params = %{name: "Yashin", currency: "brl", value: "100"}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/accounts", params)
        |> json_response(201)

      expected = %{
        "account" => %{
          "currency" => "BRL",
          "id" => response["account"]["id"],
          "name" => "Yashin",
          "value" => 10000
        }
      }

      assert response == expected
    end
  end

  describe "DELETE /api/accounts/:id" do
    test "DELETE /", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = Core.create("Yashin", "brl", "100")

      response =
        conn
        |> delete("/api/accounts/" <> account.id)
        |> json_response(201)

      expected = %{"msg" => "account_deleted"}

      assert response == expected
    end
  end
end
