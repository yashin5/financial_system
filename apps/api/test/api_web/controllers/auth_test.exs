defmodule ApiWeb.AuthTest do
  use ApiWeb.ConnCase, async: true

  import Mox

  alias FinancialSystem.Core

  describe "POST" do
    test "When token is valid, return true", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} =
        Core.create(%{
          "role" => "regular",
          "name" => "Yashin",
          "currency" => "brl",
          "value" => "100",
          "email" => "asdfg@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      {_, token} =
        Core.authenticate(%{"email" => "asdfg@gmail.com", "password" => "fp3@naDSsjh2"})

      params = %{account_id: account.id, currency: "brl", value: "100"}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/deposit", params)
        |> json_response(201)

      expected = %{
        "account_id" => response["account_id"],
        "new_balance" => 20_000
      }

      assert response == expected
    end
  end
end
