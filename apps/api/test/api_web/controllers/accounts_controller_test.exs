defmodule ApiWeb.AccountsControllerTest do
  use ApiWeb.ConnCase, async: true

  import Mox

  alias FinancialSystem.Core

  setup :verify_on_exit!

  describe "POST /api/accounts" do
    test "when params are valid, should return 201" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      params = %{
        name: "Yashin",
        currency: "brl",
        value: "100",
        email: "yaxxxxxshin@gmail.com",
        password: "fp3@naDSsjh2"
      }

      response =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> post("/api/accounts", params)
        |> json_response(201)

      expected = %{
        "account" => %{
          "currency" => "BRL",
          "id" => response["account"]["id"],
          "value" => 10000
        }
      }

      assert response == expected
    end

    test "when params is not valid, should return 400" do
      params = %{
        name: "Yashin",
        currency: "brl",
        value: 100,
        email: "yashvvvvin@gmail.com",
        password: "Fp3@nasjh2"
      }

      response =
        build_conn()
        |> put_req_header("content-type", "application/json")

        |> post("/api/accounts", params)
        |> json_response(400)

      expected = %{"error" => "invalid_value_type"}

      assert response == expected
    end
  end

  describe "DELETE /api/accounts/:id" do
    test "when params are valid, should return 200" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} =
        Core.create("Yashin", "brl", "100", "yashfffffffin@gmail.com", "fp3@naDSsjh2")
      {_, token} = Core.authenticate("yashfffffffin@gmail.com","fp3@naDSsjh2")

      response =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)

        |> delete("/api/accounts/" <> account.id)
        |> json_response(201)

      expected = %{"msg" => "account_deleted"}

      assert response == expected
    end


    
  end
end
