defmodule FinancialSystem.ApiTest do
  use FinancialSystem.ConnCase, async: true
  import Mox
  setup :verify_on_exit!

  alias FinancialSystemWeb.API.Router

  @opts Router.init([])

  describe "POST /accounts/create" do
    test "when params are valid, should return 200" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      params = %{name: "raissa", value: "100", currency: "brl"}

      #   assert response == true
      conn =
        :post
        |> conn("/accounts", Jason.encode!(params))
        |> put_req_header("content-type", "application/json")
        |> Router.call(@opts)

      IO.inspect(conn)

      assert conn.state == :sent
      assert conn.status == 201
    end

    test "when params is not valid, should return 406" do
      params = %{name: "raissa", value: 100, currency: "brl"}

      conn =
        :post
        |> conn("/accounts", Jason.encode!(params))
        |> put_req_header("content-type", "application/json")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 406
    end

    test "when header is not valid, should return 400" do
      params = %{name: "raissa", value: "100", currency: "brl"}

      conn =
        :post
        |> conn("/accounts", Jason.encode!(params))
        |> put_req_header("content-type", "application/x-www-form-urlencoded")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 400
    end
  end
end
