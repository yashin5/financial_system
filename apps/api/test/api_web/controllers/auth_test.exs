defmodule ApiWeb.AuthTest do
  use ApiWeb.ConnCase, async: true

  import Mox

  alias FinancialSystem.Core

  describe "POST" do
    test "When token is valid, make the operation", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

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

      params = %{currency: "brl", value: "100"}

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

    test "When token is not valid, not make the operation", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "role" => "regular",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "asdfg@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      token = "nhpg64X7uYI97iAbxoTfvQxO6qj5dj0D/QLsnnplHhfIUyqEbERr+AH8Q860Hd8T"

      params = %{currency: "brl", value: "100"}

      %{"message" => response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/deposit", params)
        |> json_response(401)

      error = "unauthorized"

      assert ^response = error
    end
  end
end
