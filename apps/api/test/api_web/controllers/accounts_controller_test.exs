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

      params = %{name: "Yashin", currency: "brl", value: "100"}

      response =
        build_conn()
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

    test "when params is not valid, should return 400" do
      params = %{name: "Yashin", currency: "brl", value: 100}

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

      {_, account} = Core.create("Yashin", "brl", "100")

      response =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> delete("/api/accounts/" <> account.id)
        |> json_response(201)

      expected = %{"msg" => "account_deleted"}

      assert response == expected
    end

    test "when params is not valid, should return 400" do
      params = "234"

      response =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> delete("/api/accounts/" <> params)
        |> json_response(400)

      expected = %{"error" => "invalid_account_id_type"}

      assert response == expected
    end

    test "when params are valid but the action cannot  be taken, should return 422" do
      params = UUID.uuid4()

      response =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> delete("/api/accounts/" <> params)
        |> json_response(422)

      expected = %{"error" => "account_dont_exist"}

      assert response == expected
    end
  end
end
