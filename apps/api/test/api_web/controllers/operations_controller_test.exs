defmodule ApiWeb.OperationsControllerTest do
  use ApiWeb.ConnCase, async: true

  import Mox

  alias FinancialSystem.Core

  describe "POST /api/operations/withdraw" do
    test "when params is not valid, should return 201 and the response", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "role" => "regular",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "axsd@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {_, token} = Core.authenticate(%{"email" => "axsd@gmail.com", "password" => "fp3@naDSsjh2"})

      params = %{value: "100"}

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

    test "when currency is not invalid type, should return 400", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "role" => "regular",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "axsd@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {_, token} = Core.authenticate(%{"email" => "axsd@gmail.com", "password" => "fp3@naDSsjh2"})

      params = %{value: "100"}

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

      Core.create(%{
        "role" => "regular",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "asdf@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {_, token} = Core.authenticate(%{"email" => "asdf@gmail.com", "password" => "fp3@naDSsjh2"})

      params = %{value: 100}

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
    test "when params is  valid, should return 201 and the response", %{conn: conn} do
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

    test "when all params aren't valid, should return 400 and the response", %{conn: conn} do
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

      params = %{currency: 1, value: 100}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/deposit", params)
        |> json_response(400)

      expected = %{"error" => "invalid_arguments_type"}

      assert response == expected
    end

    test "when currency is not invalid type, should return 400", %{conn: conn} do
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

      params = %{currency: 1, value: "100"}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/deposit", params)
        |> json_response(400)

      expected = %{"error" => "invalid_currency_type"}

      assert response == expected
    end

    test "when value ins equal or less than 0, should return 400", %{conn: conn} do
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

      params = %{currency: "brl", value: "-1"}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/deposit", params)
        |> json_response(400)

      expected = %{"error" => "invalid_value_less_than_0"}

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

      Core.create(%{
        "role" => "regular",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "yashin@outlook.com",
        "password" => "fp3@naDSsjh2"
      })

      params = %{email: "yashin@outlook.com", value: "100"}

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

    test "Should not be able to transfer if the account id is not string", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 3, fn currency ->
        {:ok, String.upcase(currency)}
      end)

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

      params = %{"email" => 1, "value" => "100"}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/transfer", params)
        |> json_response(422)

      expected = %{
        "error" => "invalid_email_type"
      }

      assert response == expected
    end

    test "Should not be able to transfer to an inexistenting account", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 3, fn currency ->
        {:ok, String.upcase(currency)}
      end)

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

      params = %{"email" => UUID.uuid4(), "value" => "100"}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/transfer", params)
        |> json_response(422)

      expected = %{"error" => "user_dont_exist"}

      assert response == expected
    end

    test "when params are valid but the action cannot  be taken, should return 422", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "role" => "regular",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "0",
        "email" => "aaaa@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {_, token} = Core.authenticate(%{"email" => "aaaa@gmail.com", "password" => "fp3@naDSsjh2"})

      Core.create(%{
        "role" => "regular",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "ssss@outloil.com",
        "password" => "fp3@naDSsjh2"
      })

      params = %{"email" => "ssss@outloil.com", "value" => "100"}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/transfer", params)
        |> json_response(422)

      expected = %{"error" => "do_not_have_funds"}

      assert response == expected
    end

    test "should not be able to transfer to yourself, should return 422", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "role" => "regular",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "aaaa@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {_, token} = Core.authenticate(%{"email" => "aaaa@gmail.com", "password" => "fp3@naDSsjh2"})

      params = %{"email" => "aaaa@gmail.com", "value" => "100"}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/transfer", params)
        |> json_response(422)

      expected = %{"error" => "cannot_send_to_the_same"}

      assert response == expected
    end

    test "when params is not valid, should return 400", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "role" => "regular",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "dddd@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {_, token} = Core.authenticate(%{"email" => "dddd@gmail.com", "password" => "fp3@naDSsjh2"})

      Core.create(%{
        "role" => "regular",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "fffff@outlook.com",
        "password" => "fp3@naDSsjh2"
      })

      params = %{"email" => "fffff@outlook.com", "value" => 100}

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

      Core.create(%{
        "role" => "regular",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "yashin@outlook.com",
        "password" => "fp3@naDSsjh2"
      })

      Core.create(%{
        "role" => "regular",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "gggg@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {_, token} = Core.authenticate(%{"email" => "gggg@gmail.com", "password" => "fp3@naDSsjh2"})

      Core.create(%{
        "role" => "regular",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "yashin@yahoo.com",
        "password" => "fp3@naDSsjh2"
      })

      split_list = [
        %{"email" => "yashin@outlook.com", "percent" => 50},
        %{"email" => "yashin@yahoo.com", "percent" => 50}
      ]

      params = %{split_list: split_list, value: "100"}

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

    test "should not be able to make split transfer if total percent not is 100", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 5, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "role" => "regular",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "yashin@outlook.com",
        "password" => "fp3@naDSsjh2"
      })

      Core.create(%{
        "role" => "regular",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "gggg@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {_, token} = Core.authenticate(%{"email" => "gggg@gmail.com", "password" => "fp3@naDSsjh2"})

      Core.create(%{
        "role" => "regular",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "yashin@yahoo.com",
        "password" => "fp3@naDSsjh2"
      })

      split_list = [
        %{"email" => "yashin@outlook.com", "percent" => 40},
        %{"email" => "yashin@yahoo.com", "percent" => 50}
      ]

      params = %{split_list: split_list, value: "100"}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/split", params)
        |> json_response(422)

      expected = %{"error" => "invalid_total_percent"}

      assert response == expected
    end

    test "when params are valid but the action cannot  be taken, should return 422", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 5, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "role" => "regular",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "hhhh@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      Core.create(%{
        "role" => "regular",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "0",
        "email" => "qqq@yahoo.com",
        "password" => "fp3@naDSsjh2"
      })

      {_, token} = Core.authenticate(%{"email" => "qqq@yahoo.com", "password" => "fp3@naDSsjh2"})

      Core.create(%{
        "role" => "regular",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "www@outlook.com",
        "password" => "fp3@naDSsjh2"
      })

      split_list = [
        %{"email" => "hhhh@gmail.com", "percent" => 50},
        %{"email" => "www@outlook.com", "percent" => 50}
      ]

      params = %{split_list: split_list, value: "100"}

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

      Core.create(%{
        "role" => "regular",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "eee@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      Core.create(%{
        "role" => "regular",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "rrr@yahoo.com",
        "password" => "fp3@naDSsjh2"
      })

      {_, token} = Core.authenticate(%{"email" => "rrr@yahoo.com", "password" => "fp3@naDSsjh2"})

      Core.create(%{
        "role" => "regular",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "qqq@outlook.com",
        "password" => "fp3@naDSsjh2"
      })

      split_list = [
        %{"email" => "eee@gmail.com", "percent" => 50},
        %{"email" => "qqq@outlook.com", "percent" => 50}
      ]

      params = %{split_list: split_list, value: 100}

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
    test "Should be able to get the statement from yourself", %{conn: conn} do
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
        |> get("/api/operations/financial_statement/")
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

    test "Should be able to get the statement from others too", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "role" => "admin",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "qqwqw@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

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

      {_, token} =
        Core.authenticate(%{"email" => "qqwqw@gmail.com", "password" => "fp3@naDSsjh2"})

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> get("/api/operations/financial_statement/" <> "qwqw@gmail.com")
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

  describe "GET show/1" do
    test "Should be able to get the actual value formated from yourself", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "role" => "regular",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "qwqw@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {_, token} = Core.authenticate(%{"email" => "qwqw@gmail.com", "password" => "fp3@naDSsjh2"})

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> get("/api/operations/show/")
        |> json_response(201)

      expected = %{"value_in_account" => "100.00"}

      assert response == expected
    end

    test "Should be able to get the actual value formated from an account", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "role" => "admin",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "qqwqw@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      Core.create(%{
        "role" => "regular",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "qwqw@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {_, token} =
        Core.authenticate(%{"email" => "qqwqw@gmail.com", "password" => "fp3@naDSsjh2"})

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> get("/api/operations/show/" <> "qwqw@gmail.com")
        |> json_response(201)

      expected = %{"value_in_account" => "100.00"}

      assert response == expected
    end
  end

  describe "POST creact_contact/1" do
    test "Should be able to create a new contact", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {:ok, account} =
        Core.create(%{
          "role" => "admin",
          "name" => "Yashin",
          "currency" => "brl",
          "value" => "100",
          "email" => "qqwqw@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      {_, token} =
        Core.authenticate(%{"email" => "qqwqw@gmail.com", "password" => "fp3@naDSsjh2"})

      params = %{"email" => "qqwqw@gmail.com", "nickname" => "qqqw"}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/create_contact/", params)
        |> json_response(201)

      expected = %{
        "contact" => "qqwqw@gmail.com",
        "contact_account_id" => account.id,
        "contact_nickname" => "qqqw"
      }

      assert response == expected
    end

    test "Should not be able to create a new contact if insert a invalid email", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "role" => "admin",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "qqwqw@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {_, token} =
        Core.authenticate(%{"email" => "qqwqw@gmail.com", "password" => "fp3@naDSsjh2"})

      params = %{"email" => "qqwqwgmail.com", "nickname" => "qqqw"}

      error =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/create_contact/", params)
        |> json_response(422)

      expected = %{"error" => "user_dont_exist"}

      assert error == expected
    end

    test "Should not be able to create a same contact two times", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {:ok, account} =
        Core.create(%{
          "role" => "admin",
          "name" => "Yashin",
          "currency" => "brl",
          "value" => "100",
          "email" => "qqwqw@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      {_, token} =
        Core.authenticate(%{"email" => "qqwqw@gmail.com", "password" => "fp3@naDSsjh2"})

      params = %{"email" => "qqwqw@gmail.com", "nickname" => "qqqw"}

      params |> Map.put("account_id", account.id) |> Core.create_contact()

      error =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/create_contact/", params)
        |> json_response(422)

      expected = %{"error" => "already_in_contacts"}

      assert error == expected
    end
  end

  describe "GET get_all_contacts/1" do
    test "Should be able to get all contacts from a user", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} =
        Core.create(%{
          "role" => "admin",
          "name" => "Yashin",
          "currency" => "brl",
          "value" => "100",
          "email" => "qqwqw@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      {_, token} =
        Core.authenticate(%{
          "email" => "qqwqw@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      Core.create_contact(%{
        "account_id" => account.id,
        "email" => "qqwqw@gmail.com",
        "nickname" => "qqqw"
      })

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> get("/api/operations/get_all_contacts/", %{})
        |> json_response(201)

      expected = [
        %{
          "contact_account_id" => account.id,
          "contact_email" => "qqwqw@gmail.com",
          "contact_nickname" => "qqqw"
        }
      ]

      assert response == expected
    end
  end

  describe "POST update_contact_nickname/1" do
    test "Should be able to update the nickname from a contact", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} =
        Core.create(%{
          "role" => "admin",
          "name" => "Yashin",
          "currency" => "brl",
          "value" => "100",
          "email" => "qqwqw@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      {_, token} =
        Core.authenticate(%{
          "email" => "qqwqw@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      Core.create_contact(%{
        "account_id" => account.id,
        "email" => "qqwqw@gmail.com",
        "nickname" => "qqqw"
      })

      params = %{"new_nickname" => "eu", "email" => "qqwqw@gmail.com"}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/update_contact_nickname/", params)
        |> json_response(201)

      expected = %{
        "contact" => "qqwqw@gmail.com",
        "contact_account_id" => account.id,
        "contact_nickname" => "eu"
      }

      assert response == expected
    end

    test "Should not be able to update the nickname from a contact to the same name", %{
      conn: conn
    } do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} =
        Core.create(%{
          "role" => "admin",
          "name" => "Yashin",
          "currency" => "brl",
          "value" => "100",
          "email" => "qqwqw@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      {_, token} =
        Core.authenticate(%{
          "email" => "qqwqw@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      Core.create_contact(%{
        "account_id" => account.id,
        "email" => "qqwqw@gmail.com",
        "nickname" => "qqqw"
      })

      params = %{"new_nickname" => "qqqw", "email" => "qqwqw@gmail.com"}

      error =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/update_contact_nickname/", params)
        |> json_response(422)

      expected = %{
        "error" => "contact_actual_name"
      }

      assert error == expected
    end
  end

  describe "GET view_all_accounts/0" do
    test "Should be able to get all accounts in system", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "role" => "admin",
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "qqwqw@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {_, token} =
        Core.authenticate(%{
          "email" => "qqwqw@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      [response | _] =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> get("/api/operations/view_all_accounts")
        |> json_response(201)

      expected = %{
        "contact_account_id" => "test",
        "contact_active?" => true,
        "contact_currency" => "BRL",
        "contact_user_id" => "test",
        "contact_value" => 10000
      }

      assert %{response | "contact_user_id" => "test", "contact_account_id" => "test"} == expected
    end
  end
end
