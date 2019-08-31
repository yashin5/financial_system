defmodule ApiWeb.OperationsControllerTest do
  use ApiWeb.ConnCase, async: true

  import Mox

  alias FinancialSystem.Core

  describe "POST /api/operations/withdraw" do
    test "when params is not valid, should return 201 and the response", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = Core.create("Yashin", "brl", "100", "axsd@gmail.com", "fp3@naDSsjh2")
      {_, token} = Core.authenticate("axsd@gmail.com", "fp3@naDSsjh2")

      params = %{account_id: account.id, value: "100"}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/withdraw", params)
        |> json_response(201)

      expected = %{
        "account_id" => response["account_id"],
        "new_balance" => 0
      }

      assert response == expected
    end

    test "when params is not valid, should return 400 and error message", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = Core.create("raissa", "brl", "100", "asdf@gmail.com", "fp3@naDSsjh2")
      {_, token} = Core.authenticate("asdf@gmail.com", "fp3@naDSsjh2")

      params = %{account_id: account.id, value: 100}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/withdraw", params)
        |> json_response(400)

      expected = %{"error" => "invalid_value_type"}

      assert response == expected
    end
  end

  describe "POST /api/operations/deposit" do
    test "when params is not valid, should return 201 and the response", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = Core.create("Yashin", "brl", "100", "asdfg@gmail.com", "fp3@naDSsjh2")
      {_, token} = Core.authenticate("asdfg@gmail.com", "fp3@naDSsjh2")
      params = %{account_id: account.id, currency: "brl", value: "100"}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/deposit", params)
        |> json_response(201)

      expected = %{
        "account_id" => response["account_id"],
        "new_balance" => 20000
      }

      assert response == expected
    end

    test "when params is not valid, should return 400 and error message", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = Core.create("raissa", "brl", "100", "asdfgh@gmail.com", "fp3@naDSsjh2")
      {_, token} = Core.authenticate("asdfgh@gmail.com", "fp3@naDSsjh2")

      params = %{account_id: account.id, currency: "brl", value: 100}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/deposit", params)
        |> json_response(400)

      expected = %{"error" => "invalid_value_type"}

      assert response == expected
    end
  end

  describe "POST /api/operations/transfer" do
    test "POST /", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 3, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = Core.create("raissa", "brl", "100", "asdfghh@gmail.com", "fp3@naDSsjh2")
      {_, token} = Core.authenticate("asdfghh@gmail.com", "fp3@naDSsjh2")
      {_, account2} = Core.create("yashin", "brl", "100", "yashin@outlook.com", "fp3@naDSsjh2")

      params = %{account_from: account.id, account_to: account2.id, value: "100"}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/transfer", params)
        |> json_response(201)

      expected = %{
        "account_id" => response["account_id"],
        "new_balance" => 0
      }

      assert response == expected
    end

    test "when params are valid but the action cannot  be taken, should return 422", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = Core.create("raissa", "brl", "0", "aaaa@gmail.com", "fp3@naDSsjh2")
      {_, token} = Core.authenticate("aaaa@gmail.com", "fp3@naDSsjh2")
      {_, account2} = Core.create("yashin", "brl", "100", "ssss@outloil.com", "fp3@naDSsjh2")

      params = %{account_from: account.id, account_to: account2.id, value: "100"}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/transfer", params)
        |> json_response(422)

      expected = %{"error" => "do_not_have_funds"}

      assert response == expected
    end

    test "when params is not valid, should return 400", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = Core.create("raissa", "brl", "100", "dddd@gmail.com", "fp3@naDSsjh2")
      {_, token} = Core.authenticate("dddd@gmail.com", "fp3@naDSsjh2")
      {_, account2} = Core.create("yashin", "brl", "100", "fffff@outlook.com", "fp3@naDSsjh2")

      params = %{account_from: account.id, account_to: account2.id, value: 100}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/transfer", params)
        |> json_response(400)

      expected = %{"error" => "invalid_value_type"}

      assert response == expected
    end
  end

  describe "POST /api/operations/split" do
    test "POST /", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 5, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} =
        Core.create("Yashin Santos", "BRL", "100", "yashin@outlook.com", "fp3@naDSsjh2")

      {_, account2} =
        Core.create("Antonio Marcos", "BRL", "100", "gggg@gmail.com", "fp3@naDSsjh2")

      {_, token} = Core.authenticate("gggg@gmail.com", "fp3@naDSsjh2")

      {_, account3} =
        Core.create("Mateus Mathias", "BRL", "100", "yashin@yahoo.com", "fp3@naDSsjh2")

      split_list = [
        %{account: account.id, percent: 50},
        %{account: account3.id, percent: 50}
      ]

      params = %{account_id_from: account2.id, split_list: split_list, value: "100"}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/split", params)
        |> json_response(201)

      expected = %{
        "account_id" => response["account_id"],
        "new_balance" => 0
      }

      assert response == expected
    end

    test "when params are valid but the action cannot  be taken, should return 422", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 5, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = Core.create("Yashin Santos", "BRL", "100", "hhhh@gmail.com", "fp3@naDSsjh2")

      {_, account2} = Core.create("Antonio Marcos", "BRL", "0", "qqq@yahoo.com", "fp3@naDSsjh2")
      {_, token} = Core.authenticate("qqq@yahoo.com", "fp3@naDSsjh2")

      {_, account3} =
        Core.create("Mateus Mathias", "BRL", "100", "www@outlook.com", "fp3@naDSsjh2")

      split_list = [
        %{account: account.id, percent: 50},
        %{account: account3.id, percent: 50}
      ]

      params = %{account_id_from: account2.id, split_list: split_list, value: "100"}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/split", params)
        |> json_response(422)

      expected = %{"error" => "do_not_have_funds"}

      assert response == expected
    end

    test "when params is not valid, should return 400", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 5, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = Core.create("Yashin Santos", "BRL", "100", "eee@gmail.com", "fp3@naDSsjh2")

      {_, account2} = Core.create("Antonio Marcos", "BRL", "100", "rrr@yahoo.com", "fp3@naDSsjh2")
      {_, token} = Core.authenticate("rrr@yahoo.com", "fp3@naDSsjh2")

      {_, account3} =
        Core.create("Mateus Mathias", "BRL", "100", "qqq@outlook.com", "fp3@naDSsjh2")

      split_list = [
        %{account: account.id, percent: 50},
        %{account: account3.id, percent: 50}
      ]

      params = %{account_id_from: account2.id, split_list: split_list, value: 100}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/split", params)
        |> json_response(400)

      expected = %{"error" => "invalid_value_type"}

      assert response == expected
    end
  end

  describe "GET /api/operations/financial_statement" do
    test "GET /", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} = Core.create("Yashin", "brl", "100", "qwqw@gmail.com", "fp3@naDSsjh2")
      Core.withdraw(account.id, "10")
      {_, token} = Core.authenticate("qwqw@gmail.com", "fp3@naDSsjh2")

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
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
