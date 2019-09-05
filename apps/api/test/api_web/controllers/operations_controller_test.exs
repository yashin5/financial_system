defmodule ApiWeb.OperationsControllerTest do
  use ApiWeb.ConnCase, async: true

  import Mox

  alias FinancialSystem.Core

  describe "POST /api/operations/withdraw" do
    test "when params is not valid, should return 201 and the response", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} =
        Core.create(%{
          "role" => "regular",
          "name" => "Yashin",
          "currency" => "brl",
          "value" => "100",
          "email" => "axsd@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      {_, token} = Core.authenticate(%{"email" => "axsd@gmail.com", "password" => "fp3@naDSsjh2"})

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

      {_, account} =
        Core.create(%{
          "role" => "regular",
          "name" => "Yashin",
          "currency" => "brl",
          "value" => "100",
          "email" => "asdf@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      {_, token} = Core.authenticate(%{"email" => "asdf@gmail.com", "password" => "fp3@naDSsjh2"})

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

    test "when params is not valid, should return 400 and error message", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} =
        Core.create(%{
          "role" => "regular",
          "name" => "Yashin",
          "currency" => "brl",
          "value" => "100",
          "email" => "asdfgh@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      {_, token} =
        Core.authenticate(%{"email" => "asdfgh@gmail.com", "password" => "fp3@naDSsjh2"})

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

      {_, account} =
        Core.create(%{
          "role" => "regular",
          "name" => "Yashin",
          "currency" => "brl",
          "value" => "100",
          "email" => "asdfghh@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      {_, token} =
        Core.authenticate(%{"email" => "asdfghh@gmail.com", "password" => "fp3@naDSsjh2"})

      {_, account2} =
        Core.create(%{
          "role" => "regular",
          "name" => "Yashin",
          "currency" => "brl",
          "value" => "100",
          "email" => "yashin@outlook.com",
          "password" => "fp3@naDSsjh2"
        })

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

      {_, account} =
        Core.create(%{
          "role" => "regular",
          "name" => "Yashin",
          "currency" => "brl",
          "value" => "0",
          "email" => "aaaa@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      {_, token} = Core.authenticate(%{"email" => "aaaa@gmail.com", "password" => "fp3@naDSsjh2"})

      {_, account2} =
        Core.create(%{
          "role" => "regular",
          "name" => "Yashin",
          "currency" => "brl",
          "value" => "100",
          "email" => "ssss@outloil.com",
          "password" => "fp3@naDSsjh2"
        })

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

      {_, account} =
        Core.create(%{
          "role" => "regular",
          "name" => "Yashin",
          "currency" => "brl",
          "value" => "100",
          "email" => "dddd@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      {_, token} = Core.authenticate(%{"email" => "dddd@gmail.com", "password" => "fp3@naDSsjh2"})

      {_, account2} =
        Core.create(%{
          "role" => "regular",
          "name" => "Yashin",
          "currency" => "brl",
          "value" => "100",
          "email" => "fffff@outlook.com",
          "password" => "fp3@naDSsjh2"
        })

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
        Core.create(%{
          "role" => "regular",
          "name" => "Yashin",
          "currency" => "brl",
          "value" => "100",
          "email" => "yashin@outlook.com",
          "password" => "fp3@naDSsjh2"
        })

      {_, account2} =
        Core.create(%{
          "role" => "regular",
          "name" => "Yashin",
          "currency" => "brl",
          "value" => "100",
          "email" => "gggg@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      {_, token} = Core.authenticate(%{"email" => "gggg@gmail.com", "password" => "fp3@naDSsjh2"})

      {_, account3} =
        Core.create(%{
          "role" => "regular",
          "name" => "Yashin",
          "currency" => "brl",
          "value" => "100",
          "email" => "yashin@yahoo.com",
          "password" => "fp3@naDSsjh2"
        })

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

      {_, account} =
        Core.create(%{
          "role" => "regular",
          "name" => "Yashin",
          "currency" => "brl",
          "value" => "100",
          "email" => "hhhh@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      {_, account2} =
        Core.create(%{
          "role" => "regular",
          "name" => "Yashin",
          "currency" => "brl",
          "value" => "0",
          "email" => "qqq@yahoo.com",
          "password" => "fp3@naDSsjh2"
        })

      {_, token} = Core.authenticate(%{"email" => "qqq@yahoo.com", "password" => "fp3@naDSsjh2"})

      {_, account3} =
        Core.create(%{
          "role" => "regular",
          "name" => "Yashin",
          "currency" => "brl",
          "value" => "100",
          "email" => "www@outlook.com",
          "password" => "fp3@naDSsjh2"
        })

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

      {_, account} =
        Core.create(%{
          "role" => "regular",
          "name" => "Yashin",
          "currency" => "brl",
          "value" => "100",
          "email" => "eee@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      {_, account2} =
        Core.create(%{
          "role" => "regular",
          "name" => "Yashin",
          "currency" => "brl",
          "value" => "100",
          "email" => "rrr@yahoo.com",
          "password" => "fp3@naDSsjh2"
        })

      {_, token} = Core.authenticate(%{"email" => "rrr@yahoo.com", "password" => "fp3@naDSsjh2"})

      {_, account3} =
        Core.create(%{
          "role" => "regular",
          "name" => "Yashin",
          "currency" => "brl",
          "value" => "100",
          "email" => "qqq@outlook.com",
          "password" => "fp3@naDSsjh2"
        })

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

      {_, account} =
        Core.create(%{
          "role" => "regular",
          "name" => "Yashin",
          "currency" => "brl",
          "value" => "100",
          "email" => "qwqw@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      Core.withdraw(%{
        "account_id" => account.id,
        "value" => "10"
      })

      {_, token} = Core.authenticate(%{"email" => "qwqw@gmail.com", "password" => "fp3@naDSsjh2"})

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
