defmodule ApiWeb.OperationsControllerTest do
  use ApiWeb.ConnCase, async: true

  import Mox

  alias FinancialSystem.Core
  alias FinancialSystem.Core.Accounts.Account
  alias FinancialSystem.Core.Users.User

  describe "POST /api/operations/withdraw" do
    test "when params is not valid, should return 201 and the response", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "axsd@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {:ok, token} =
        Core.authenticate(%{"email" => "axsd@gmail.com", "password" => "fp3@naDSsjh2"})

      params = %{value: "100"}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/withdraw", params)
        |> json_response(201)

      expected = %{
        "account_id" => response["account_id"],
        "new_balance" => "0.00"
      }

      assert response == expected
    end

    test "when currency is not invalid type, should return 400", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "axsd@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {:ok, token} =
        Core.authenticate(%{"email" => "axsd@gmail.com", "password" => "fp3@naDSsjh2"})

      params = %{value: "100"}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/withdraw", params)
        |> json_response(201)

      expected = %{
        "account_id" => response["account_id"],
        "new_balance" => "0.00"
      }

      assert response == expected
    end

    test "when params is not valid, should return 400 and error message", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "asdf@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {:ok, token} =
        Core.authenticate(%{"email" => "asdf@gmail.com", "password" => "fp3@naDSsjh2"})

      params = %{value: 100}

      %{"error" => response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/withdraw", params)
        |> json_response(400)

      error = "invalid_value_type"

      assert ^response = error
    end
  end

  describe "POST /api/operations/deposit" do
    test "when params is  valid, should return 201 and the response", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "asdfg@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {:ok, token} =
        Core.authenticate(%{"email" => "asdfg@gmail.com", "password" => "fp3@naDSsjh2"})

      params = %{currency: "BRL", value: "100"}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/deposit", params)
        |> json_response(201)

      expected = %{
        "account_id" => response["account_id"],
        "new_balance" => "200.00"
      }

      assert response == expected
    end

    test "when all params aren't valid, should return 400 and the response", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "asdfg@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {:ok, token} =
        Core.authenticate(%{"email" => "asdfg@gmail.com", "password" => "fp3@naDSsjh2"})

      params = %{currency: 1, value: 100}

      %{"error" => response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/deposit", params)
        |> json_response(400)

      error = "invalid_arguments_type"

      assert ^response = error
    end

    test "value when converted become to zero, should return 400", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "asdfg@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {:ok, token} =
        Core.authenticate(%{"email" => "asdfg@gmail.com", "password" => "fp3@naDSsjh2"})

      params = %{currency: "MZN", value: "0.01"}

      %{"error" => response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/deposit", params)
        |> json_response(400)

      error = "value_is_too_low_to_convert_to_the_currency"

      assert ^response = error
    end

    test "when currency is not invalid type, should return 400", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "asdfg@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {:ok, token} =
        Core.authenticate(%{"email" => "asdfg@gmail.com", "password" => "fp3@naDSsjh2"})

      params = %{currency: 1, value: "100"}

      %{"error" => response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/deposit", params)
        |> json_response(400)

      error = "invalid_currency_type"

      assert ^response = error
    end

    test "when value ins equal or less than 0, should return 400", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "asdfg@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {:ok, token} =
        Core.authenticate(%{"email" => "asdfg@gmail.com", "password" => "fp3@naDSsjh2"})

      params = %{currency: "BRL", value: "-1"}

      %{"error" => response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/deposit", params)
        |> json_response(400)

      error = "invalid_value_less_than_0"

      assert ^response = error
    end

    test "when params is not valid, should return 400 and error message", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {:ok, account} =
        Core.create(%{
          "name" => "Yashin",
          "currency" => "BRL",
          "value" => "100",
          "email" => "asdfgh@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      {:ok, token} =
        Core.authenticate(%{"email" => "asdfgh@gmail.com", "password" => "fp3@naDSsjh2"})

      params = %{account_id: account.id, currency: "BRL", value: 100}

      %{"error" => response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/deposit", params)
        |> json_response(400)

      expected = "invalid_value_type"

      assert response == expected
    end
  end

  describe "POST /api/operations/transfer" do
    test "POST /", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 4, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "asdfghh@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {:ok, token} =
        Core.authenticate(%{"email" => "asdfghh@gmail.com", "password" => "fp3@naDSsjh2"})

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
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
        "new_balance" => "0.00"
      }

      assert response == expected
    end

    test "Should not be able to transfer if the account id is not string", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 3, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "asdfghh@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {:ok, token} =
        Core.authenticate(%{"email" => "asdfghh@gmail.com", "password" => "fp3@naDSsjh2"})

      params = %{"email" => 1, "value" => "100"}

      %{"error" => response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/transfer", params)
        |> json_response(422)

      error = "invalid_email_type"

      assert ^response = error
    end

    test "Should not be able to transfer to an inexistenting account", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 3, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "asdfghh@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {:ok, token} =
        Core.authenticate(%{"email" => "asdfghh@gmail.com", "password" => "fp3@naDSsjh2"})

      params = %{"email" => UUID.uuid4(), "value" => "100"}

      %{"error" => response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/transfer", params)
        |> json_response(422)

      error = "user_dont_exist"

      assert ^response = error
    end

    test "when params are valid but the action cannot  be taken, should return 422", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 3, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "0",
        "email" => "aaaa@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {:ok, token} =
        Core.authenticate(%{"email" => "aaaa@gmail.com", "password" => "fp3@naDSsjh2"})

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "ssss@outloil.com",
        "password" => "fp3@naDSsjh2"
      })

      params = %{"email" => "ssss@outloil.com", "value" => "100"}

      %{"error" => response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/transfer", params)
        |> json_response(422)

      error = "do_not_have_funds"

      assert ^response = error
    end

    test "should not be able to transfer to yourself, should return 422", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "aaaa@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {:ok, token} =
        Core.authenticate(%{"email" => "aaaa@gmail.com", "password" => "fp3@naDSsjh2"})

      params = %{"email" => "aaaa@gmail.com", "value" => "100"}

      %{"error" => response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/transfer", params)
        |> json_response(422)

      error = "cannot_send_to_the_same"

      assert ^response = error
    end

    test "when params is not valid, should return 400", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "dddd@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {:ok, token} =
        Core.authenticate(%{"email" => "dddd@gmail.com", "password" => "fp3@naDSsjh2"})

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "fffff@outlook.com",
        "password" => "fp3@naDSsjh2"
      })

      params = %{"email" => "fffff@outlook.com", "value" => 100}

      %{"error" => response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/transfer", params)
        |> json_response(400)

      error = "invalid_value_type"

      assert ^response = error
    end
  end

  describe "POST /api/operations/split" do
    test "POST /", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 9, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "yashin@outlook.com",
        "password" => "fp3@naDSsjh2"
      })

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "gggg@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {:ok, token} =
        Core.authenticate(%{"email" => "gggg@gmail.com", "password" => "fp3@naDSsjh2"})

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
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
        "new_balance" => "0.00"
      }

      assert response == expected
    end

    test "When try make a split transfer to a inexistent account, should return 422", %{
      conn: conn
    } do
      expect(CurrencyMock, :currency_is_valid, 9, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "yashin@outlook.com",
        "password" => "fp3@naDSsjh2"
      })

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "gggg@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {:ok, token} =
        Core.authenticate(%{"email" => "gggg@gmail.com", "password" => "fp3@naDSsjh2"})

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "yashin@yahoo.com",
        "password" => "fp3@naDSsjh2"
      })

      split_list = [
        %{"email" => "syashin@outlook.com", "percent" => 50},
        %{"email" => "yashin@yahoo.com", "percent" => 50}
      ]

      params = %{split_list: split_list, value: "100"}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/split", params)
        |> json_response(422)

      expected = %{"error" => "user_dont_exist"}

      assert response == expected
    end

    test "should not be able to make split transfer if total percent not is 100", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 5, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "yashin@outlook.com",
        "password" => "fp3@naDSsjh2"
      })

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "gggg@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {:ok, token} =
        Core.authenticate(%{"email" => "gggg@gmail.com", "password" => "fp3@naDSsjh2"})

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "yashin@yahoo.com",
        "password" => "fp3@naDSsjh2"
      })

      split_list = [
        %{"email" => "yashin@outlook.com", "percent" => 40},
        %{"email" => "yashin@yahoo.com", "percent" => 50}
      ]

      params = %{split_list: split_list, value: "100"}

      %{"error" => response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/split", params)
        |> json_response(422)

      error = "invalid_total_percent"

      assert ^response = error
    end

    test "when params are valid but the action cannot  be taken, should return 422", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 5, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "hhhh@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "0",
        "email" => "qqq@yahoo.com",
        "password" => "fp3@naDSsjh2"
      })

      {:ok, token} =
        Core.authenticate(%{"email" => "qqq@yahoo.com", "password" => "fp3@naDSsjh2"})

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "www@outlook.com",
        "password" => "fp3@naDSsjh2"
      })

      split_list = [
        %{"email" => "hhhh@gmail.com", "percent" => 50},
        %{"email" => "www@outlook.com", "percent" => 50}
      ]

      params = %{split_list: split_list, value: "100"}

      %{"error" => response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/split", params)
        |> json_response(422)

      error = "do_not_have_funds"

      assert ^response = error
    end

    test "when params is not valid, should return 400", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 5, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "eee@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "rrr@yahoo.com",
        "password" => "fp3@naDSsjh2"
      })

      {:ok, token} =
        Core.authenticate(%{"email" => "rrr@yahoo.com", "password" => "fp3@naDSsjh2"})

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "qqq@outlook.com",
        "password" => "fp3@naDSsjh2"
      })

      split_list = [
        %{"email" => "eee@gmail.com", "percent" => 50},
        %{"email" => "qqq@outlook.com", "percent" => 50}
      ]

      params = %{split_list: split_list, value: 100}

      %{"error" => response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/split", params)
        |> json_response(400)

      error = "invalid_value_type"

      assert ^response = error
    end
  end

  describe "GET /api/operations/financial_statement" do
    test "Should be able to get the statement from yourself", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {:ok, account} =
        Core.create(%{
          "name" => "Yashin",
          "currency" => "BRL",
          "value" => "100",
          "email" => "qwqw@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      Core.withdraw(%{
        "account_id" => account.id,
        "value" => "10"
      })

      {:ok, token} =
        Core.authenticate(%{"email" => "qwqw@gmail.com", "password" => "fp3@naDSsjh2"})

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

      {:ok, user} =
        %User{}
        |> User.changeset(%{
          role: "admin",
          name: "Yashin",
          email: "qqqwqw@gmail.com",
          password: "fp3@naDSsjh2"
        })
        |> Repo.insert()

      user
      |> Ecto.build_assoc(:account, %{})
      |> Account.changeset(%{
        active: true,
        currency: "BRL",
        value: "10000"
      })
      |> Repo.insert()

      {:ok, account} =
        Core.create(%{
          "name" => "Yashin",
          "currency" => "BRL",
          "value" => "100",
          "email" => "qwqw@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      Core.withdraw(%{
        "account_id" => account.id,
        "value" => "10"
      })

      {:ok, token} =
        Core.authenticate(%{"email" => "qqqwqw@gmail.com", "password" => "fp3@naDSsjh2"})

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
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "qwqw@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {:ok, token} =
        Core.authenticate(%{"email" => "qwqw@gmail.com", "password" => "fp3@naDSsjh2"})

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> get("/api/operations/show/")
        |> json_response(201)

        expected = %{
          "email" => "qwqw@gmail.com",
          "value_in_account" => %{
            "currency" => "BRL",
            "currency_precision" => 2,
            "value" => "100.00"
          }
        }

      assert response == expected
    end

    test "Should be able to get the actual value formated from an account", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {:ok, user} =
        %User{}
        |> User.changeset(%{
          role: "admin",
          name: "Yashin",
          email: "wqqwqw@gmail.com",
          password: "fp3@naDSsjh2"
        })
        |> Repo.insert()

      user
      |> Ecto.build_assoc(:account, %{})
      |> Account.changeset(%{
        active: true,
        currency: "BRL",
        value: "10000"
      })
      |> Repo.insert()

      Core.create(%{
        "name" => "Yashin",
        "currency" => "BRL",
        "value" => "100",
        "email" => "qwqw@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {:ok, token} =
        Core.authenticate(%{"email" => "wqqwqw@gmail.com", "password" => "fp3@naDSsjh2"})

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> get("/api/operations/show/" <> "qwqw@gmail.com")
        |> json_response(201)

        expected = %{
          "email" => "wqqwqw@gmail.com",
          "value_in_account" => %{
            "currency" => "BRL",
            "currency_precision" => 2,
            "value" => "100.00"
          }
        }

      assert response == expected
    end
  end

  describe "POST creact_contact/1" do
    test "Should be able to create a new contact", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {:ok, user} =
        %User{}
        |> User.changeset(%{
          role: "admin",
          name: "Yashin",
          email: "qqwqrw@gmail.com",
          password: "fp3@naDSsjh2"
        })
        |> Repo.insert()

      {:ok, account} =
        user
        |> Ecto.build_assoc(:account, %{})
        |> Account.changeset(%{
          active: true,
          currency: "BRL",
          value: "10000"
        })
        |> Repo.insert()

      {:ok, token} =
        Core.authenticate(%{"email" => "qqwqrw@gmail.com", "password" => "fp3@naDSsjh2"})

      params = %{"email" => "qqwqrw@gmail.com", "nickname" => "qqqw"}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/create_contact/", params)
        |> json_response(201)

      expected = %{
        "contact" => "qqwqrw@gmail.com",
        "contact_account_id" => account.id,
        "contact_nickname" => "qqqw"
      }

      assert response == expected
    end

    test "Should not be able to create a new contact if insert a invalid email", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {:ok, user} =
        %User{}
        |> User.changeset(%{
          role: "admin",
          name: "Yashin",
          email: "qqxwqw@gmail.com",
          password: "fp3@naDSsjh2"
        })
        |> Repo.insert()

      user
      |> Ecto.build_assoc(:account, %{})
      |> Account.changeset(%{
        active: true,
        currency: "BRL",
        value: "10000"
      })
      |> Repo.insert()

      {:ok, token} =
        Core.authenticate(%{"email" => "qqxwqw@gmail.com", "password" => "fp3@naDSsjh2"})

      params = %{"email" => "qqxwqw.com", "nickname" => "qqqw"}

      %{"error" => response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/create_contact/", params)
        |> json_response(422)

      error = "user_dont_exist"

      assert ^response = error
    end

    test "Should not be able to create a same contact two times", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {:ok, user} =
        %User{}
        |> User.changeset(%{
          role: "admin",
          name: "Yashin",
          email: "qcqwqw@gmail.com",
          password: "fp3@naDSsjh2"
        })
        |> Repo.insert()

      {:ok, account} =
        user
        |> Ecto.build_assoc(:account, %{})
        |> Account.changeset(%{
          active: true,
          currency: "BRL",
          value: "10000"
        })
        |> Repo.insert()

      {:ok, token} =
        Core.authenticate(%{"email" => "qcqwqw@gmail.com", "password" => "fp3@naDSsjh2"})

      params = %{"email" => "qcqwqw@gmail.com", "nickname" => "qqqw"}

      params |> Map.put("account_id", account.id) |> Core.create_contact()

      %{"error" => response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/create_contact/", params)
        |> json_response(422)

      error = "already_in_contacts"

      assert ^response = error
    end
  end

  describe "GET get_all_contacts/1" do
    test "Should be able to get all contacts from a user", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {:ok, user} =
        %User{}
        |> User.changeset(%{
          role: "admin",
          name: "Yashin",
          email: "qrrqwqw@gmail.com",
          password: "fp3@naDSsjh2"
        })
        |> Repo.insert()

      {:ok, account} =
        user
        |> Ecto.build_assoc(:account, %{})
        |> Account.changeset(%{
          active: true,
          currency: "BRL",
          value: "10000"
        })
        |> Repo.insert()

      {:ok, token} =
        Core.authenticate(%{
          "email" => "qrrqwqw@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      Core.create_contact(%{
        "account_id" => account.id,
        "email" => "qrrqwqw@gmail.com",
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
          "contact_email" => "qrrqwqw@gmail.com",
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

      {:ok, user} =
        %User{}
        |> User.changeset(%{
          role: "admin",
          name: "Yashin",
          email: "qqxxwqw@gmail.com",
          password: "fp3@naDSsjh2"
        })
        |> Repo.insert()

      {:ok, account} =
        user
        |> Ecto.build_assoc(:account, %{})
        |> Account.changeset(%{
          active: true,
          currency: "BRL",
          value: "10000"
        })
        |> Repo.insert()

      {:ok, token} =
        Core.authenticate(%{
          "email" => "qqxxwqw@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      Core.create_contact(%{
        "account_id" => account.id,
        "email" => "qqxxwqw@gmail.com",
        "nickname" => "qqqw"
      })

      params = %{"new_nickname" => "eu", "email" => "qqxxwqw@gmail.com"}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/update_contact_nickname/", params)
        |> json_response(201)

      expected = %{
        "contact" => "qqxxwqw@gmail.com",
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

      {:ok, user} =
        %User{}
        |> User.changeset(%{
          role: "admin",
          name: "Yashin",
          email: "qqwzzqw@gmail.com",
          password: "fp3@naDSsjh2"
        })
        |> Repo.insert()

      {:ok, account} =
        user
        |> Ecto.build_assoc(:account, %{})
        |> Account.changeset(%{
          active: true,
          currency: "BRL",
          value: "10000"
        })
        |> Repo.insert()

      {:ok, token} =
        Core.authenticate(%{
          "email" => "qqwzzqw@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      Core.create_contact(%{
        "account_id" => account.id,
        "email" => "qqwzzqw@gmail.com",
        "nickname" => "qqqw"
      })

      params = %{"new_nickname" => "qqqw", "email" => "qqwzzqw@gmail.com"}

      %{"error" => response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> post("/api/operations/update_contact_nickname/", params)
        |> json_response(422)

      error = "contact_actual_name"

      assert ^response = error
    end
  end

  describe "GET view_all_accounts/0" do
    test "Should be able to get all accounts in system", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {:ok, user} =
        %User{}
        |> User.changeset(%{
          role: "admin",
          name: "Yashin",
          email: "qqwqwq@gmail.com",
          password: "fp3@naDSsjh2"
        })
        |> Repo.insert()

      user
      |> Ecto.build_assoc(:account, %{})
      |> Account.changeset(%{
        active: true,
        currency: "BRL",
        value: "10000"
      })
      |> Repo.insert()

      {:ok, token} =
        Core.authenticate(%{
          "email" => "qqwqwq@gmail.com",
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
        "contact_value" => 10_000
      }

      assert %{response | "contact_user_id" => "test", "contact_account_id" => "test"} == expected
    end
  end
end
