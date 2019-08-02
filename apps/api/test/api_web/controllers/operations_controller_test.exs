defmodule ApiWeb.OperationsControllerTest do
  use ApiWeb.ConnCase, async: true

  import Mox

  alias FinancialSystem.Core

  describe "POST /api/operations/withdraw" do
    test "when params is not valid, should return 201 and the response" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = Core.create("Yashin", "brl", "100")

      params = %{account_id: account.id, value: "100"}

      response =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> post("/api/operations/withdraw", params)
        |> json_response(201)

      expected = %{
        "account_id" => response["account_id"],
        "new_balance" => 0
      }

      assert response == expected
    end

    test "when params is not valid, should return 400 and error message" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = Core.create("raissa", "brl", "100")

      params = %{account_id: account.id, value: 100}

      response =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> post("/api/operations/withdraw", params)
        |> json_response(400)

      expected = %{"error" => "invalid_value_type"}

      assert response == expected
    end

    test "when params are valid but the action cannot  be taken, should return 422 and error message" do
      params = %{account_id: UUID.uuid4(), value: "100"}

      response =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> post("/api/operations/withdraw", params)
        |> json_response(422)

      expected = %{"error" => "account_dont_exist"}

      assert response == expected
    end
  end

  describe "POST /api/operations/deposit" do
    test "when params is not valid, should return 201 and the response" do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = Core.create("Yashin", "brl", "100")

      params = %{account_id: account.id, currency: "brl", value: "100"}

      response =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> post("/api/operations/deposit", params)
        |> json_response(201)

      expected = %{
        "account_id" => response["account_id"],
        "new_balance" => 20000
      }

      assert response == expected
    end

    test "when params are valid but the action cannot  be taken, should return 422 and error message" do
      params = %{account_id: UUID.uuid4(), currency: "brl", value: "100"}

      response =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> post("/api/operations/deposit", params)
        |> json_response(422)

      expected = %{"error" => "account_dont_exist"}

      assert response == expected
    end

    test "when params is not valid, should return 400 and error message" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = Core.create("raissa", "brl", "100")

      params = %{account_id: account.id, currency: "brl", value: 100}

      response =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> post("/api/operations/deposit", params)
        |> json_response(400)

      expected = %{"error" => "invalid_value_type"}

      assert response == expected
    end
  end

  describe "POST /api/operations/transfer" do
    test "POST /" do
      expect(CurrencyMock, :currency_is_valid, 3, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = Core.create("raissa", "brl", "100")

      {_, account2} = Core.create("yashin", "brl", "100")

      params = %{account_from: account.id, account_to: account2.id, value: "100"}

      response =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> post("/api/operations/transfer", params)
        |> json_response(201)

      expected = %{
        "account_id" => response["account_id"],
        "new_balance" => 0
      }

      assert response == expected
    end

    test "when params are valid but the action cannot  be taken, should return 422" do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = Core.create("raissa", "brl", "0")

      {_, account2} = Core.create("yashin", "brl", "100")

      params = %{account_from: account.id, account_to: account2.id, value: "100"}

      response =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> post("/api/operations/transfer", params)
        |> json_response(422)

      expected = %{"error" => "do_not_have_funds"}

      assert response == expected
    end

    test "when params is not valid, should return 400" do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = Core.create("raissa", "brl", "100")

      {_, account2} = Core.create("yashin", "brl", "100")

      params = %{account_from: account.id, account_to: account2.id, value: 100}

      response =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> post("/api/operations/transfer", params)
        |> json_response(400)

      expected = %{"error" => "invalid_value_type"}

      assert response == expected
    end
  end

  describe "POST /api/operations/split" do
    test "POST /" do
      expect(CurrencyMock, :currency_is_valid, 5, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = Core.create("Yashin Santos", "BRL", "100")

      {_, account2} = Core.create("Antonio Marcos", "BRL", "100")
      {_, account3} = Core.create("Mateus Mathias", "BRL", "100")

      split_list = [
        %{account: account.id, percent: 50},
        %{account: account3.id, percent: 50}
      ]

      params = %{account_id_from: account2.id, split_list: split_list, value: "100"}

      response =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> post("/api/operations/split", params)
        |> json_response(201)

      expected = %{
        "account_id" => response["account_id"],
        "new_balance" => 0
      }

      assert response == expected
    end

    test "when params are valid but the action cannot  be taken, should return 422" do
      expect(CurrencyMock, :currency_is_valid, 5, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = Core.create("Yashin Santos", "BRL", "100")

      {_, account2} = Core.create("Antonio Marcos", "BRL", "0")
      {_, account3} = Core.create("Mateus Mathias", "BRL", "100")

      split_list = [
        %{account: account.id, percent: 50},
        %{account: account3.id, percent: 50}
      ]

      params = %{account_id_from: account2.id, split_list: split_list, value: "100"}

      response =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> post("/api/operations/split", params)
        |> json_response(422)

      expected = %{"error" => "do_not_have_funds"}

      assert response == expected
    end

    test "when params is not valid, should return 400" do
      expect(CurrencyMock, :currency_is_valid, 5, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = Core.create("Yashin Santos", "BRL", "100")

      {_, account2} = Core.create("Antonio Marcos", "BRL", "100")
      {_, account3} = Core.create("Mateus Mathias", "BRL", "100")

      split_list = [
        %{account: account.id, percent: 50},
        %{account: account3.id, percent: 50}
      ]

      params = %{account_id_from: account2.id, split_list: split_list, value: 100}

      response =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> post("/api/operations/split", params)
        |> json_response(400)

      expected = %{"error" => "invalid_value_type"}

      assert response == expected
    end
  end

  describe "GET /api/operations/financial_statement" do
    test "GET /" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = Core.create("Yashin", "brl", "100")
      Core.withdraw(account.id, "10")

      response =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> get("/api/operations/financial_statement/" <> account.id)
        |> json_response(201)

      expected = %{
        "account_id" => account.id,
        "transactions" => [%{"operation" => "withdraw", "value" => 1000, "inserted_at" => 0}]
      }

      expected_transaction =
        Enum.map(response["transactions"], fn item -> %{item | "inserted_at" => 0} end)

      response_handled = %{response | "transactions" => expected_transaction}

      assert response_handled == expected
    end
  end
end
