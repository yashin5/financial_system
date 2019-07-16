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

  describe "POST /operations/withdraw" do
    test "when params are valid, should return 200" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = FinancialSystem.create("raissa", "brl", "100")

      params = %{account_id: account.id, value: "100"}

      #   assert response == true
      conn =
        :post
        |> conn("/operations/withdraw", Jason.encode!(params))
        |> put_req_header("content-type", "application/json")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 201
    end

    test "when params is not valid, should return 406" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = FinancialSystem.create("raissa", "brl", "100")

      params = %{account_id: account.id, value: 100}

      conn =
        :post
        |> conn("/operations/withdraw", Jason.encode!(params))
        |> put_req_header("content-type", "application/json")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 406
    end

    test "when header is not valid, should return 400" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = FinancialSystem.create("raissa", "brl", "100")

      params = %{account_id: account.id, value: "100"}

      conn =
        :post
        |> conn("/operations/withdraw", Jason.encode!(params))
        |> put_req_header("content-type", "application/x-www-form-urlencoded")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 400
    end
  end

  describe "POST /operations/deposit" do
    test "when params are valid, should return 200" do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = FinancialSystem.create("raissa", "brl", "100")

      params = %{account_id: account.id, currency: "brl", value: "100"}

      #   assert response == true
      conn =
        :post
        |> conn("/operations/deposit", Jason.encode!(params))
        |> put_req_header("content-type", "application/json")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 201
    end

    test "when params is not valid, should return 406" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = FinancialSystem.create("raissa", "brl", "100")

      params = %{account_id: account.id, currency: "brl", value: 100}

      conn =
        :post
        |> conn("/operations/deposit", Jason.encode!(params))
        |> put_req_header("content-type", "application/json")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 406
    end

    test "when header is not valid, should return 400" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = FinancialSystem.create("raissa", "brl", "100")

      params = %{account_id: account.id, currency: "brl", value: "100"}

      conn =
        :post
        |> conn("/operations/deposit", Jason.encode!(params))
        |> put_req_header("content-type", "application/x-www-form-urlencoded")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 400
    end
  end

  describe "POST /operations/transfer" do
    test "when params are valid, should return 200" do
      expect(CurrencyMock, :currency_is_valid, 3, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = FinancialSystem.create("raissa", "brl", "100")

      {_, account2} = FinancialSystem.create("yashin", "brl", "100")

      params = %{account_from: account.id, account_to: account2.id, value: "100"}

      #   assert response == true
      conn =
        :post
        |> conn("/operations/transfer", Jason.encode!(params))
        |> put_req_header("content-type", "application/json")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 201
    end

    test "when params is not valid, should return 406" do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = FinancialSystem.create("raissa", "brl", "100")

      {_, account2} = FinancialSystem.create("yashin", "brl", "100")

      params = %{account_from: account.id, account_to: account2.id, value: 100}

      conn =
        :post
        |> conn("/operations/transfer", Jason.encode!(params))
        |> put_req_header("content-type", "application/json")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 406
    end

    test "when header is not valid, should return 400" do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = FinancialSystem.create("raissa", "brl", "100")

      {_, account2} = FinancialSystem.create("yashin", "brl", "100")

      params = %{account_from: account.id, account_to: account2.id, value: "100"}

      conn =
        :post
        |> conn("/operations/transfer", Jason.encode!(params))
        |> put_req_header("content-type", "application/x-www-form-urlencoded")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 400
    end
  end

  describe "DELETE /accounts/:id" do
    test "when params are valid, should return 200" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = FinancialSystem.create("raissa", "brl", "100")
      params = account.id
      #   assert response == true
      conn =
        :delete
        |> conn("/accounts/" <> params)
        |> put_req_header("content-type", "application/x-www-form-urlencoded")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 201
    end

    test "when params is not valid, should return 406" do
      conn =
        :delete
        |> conn("/accounts/" <> "234")
        |> put_req_header("content-type", "application/json")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 406
    end
  end

  describe "POST /operations/split" do
    test "when params are valid, should return 200" do
      expect(CurrencyMock, :currency_is_valid, 5, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "100")
      {_, account2} = FinancialSystem.create("Antonio Marcos", "BRL", "100")
      {_, account3} = FinancialSystem.create("Mateus Mathias", "BRL", "100")

      split_list = [
        %{account: account.id, percent: 50},
        %{account: account3.id, percent: 50}
      ]

      params = %{account_id_from: account2.id, split_list: split_list, value: "100"}

      #   assert response == true
      conn =
        :post
        |> conn("/operations/split", Jason.encode!(params))
        |> put_req_header("content-type", "application/json")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 201
    end

    test "when params is not valid, should return 406" do
      expect(CurrencyMock, :currency_is_valid, 3, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "100")
      {_, account2} = FinancialSystem.create("Antonio Marcos", "BRL", "100")
      {_, account3} = FinancialSystem.create("Mateus Mathias", "BRL", "100")

      split_list = [
        %{account: account.id, percent: 50},
        %{account: account3.id, percent: 50}
      ]

      params = %{account_id_from: account2.id, split_list: split_list, value: 100}

      conn =
        :post
        |> conn("/operations/split", Jason.encode!(params))
        |> put_req_header("content-type", "application/json")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 406
    end

    test "when header is not valid, should return 400" do
      expect(CurrencyMock, :currency_is_valid, 3, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = FinancialSystem.create("Yashin Santos", "BRL", "100")
      {_, account2} = FinancialSystem.create("Antonio Marcos", "BRL", "100")
      {_, account3} = FinancialSystem.create("Mateus Mathias", "BRL", "100")

      split_list = [
        %{account: account.id, percent: 50},
        %{account: account3.id, percent: 50}
      ]

      params = %{account_id_from: account2.id, split_list: split_list, value: "100"}

      conn =
        :post
        |> conn("/operations/split", Jason.encode!(params))
        |> put_req_header("content-type", "application/x-www-form-urlencoded")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 400
    end
  end

  describe "GET /operations/financial_statement" do
    test "when params are valid, should return 200" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = FinancialSystem.create("raissa", "brl", "100")
      params = account.id
      #   assert response == true
      conn =
        :get
        |> conn("/operations/financial_statement/" <> params)
        |> put_req_header("content-type", "application/x-www-form-urlencoded")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 200
    end

    test "when account does not exist, should return 404" do
      params = UUID.uuid4()
      #   assert response == true
      conn =
        :get
        |> conn("/operations/financial_statement/" <> params)
        |> put_req_header("content-type", "application/x-www-form-urlencoded")
        |> Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 406
    end
  end
end
