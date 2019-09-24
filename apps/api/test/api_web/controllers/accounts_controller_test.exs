defmodule ApiWeb.AccountsControllerTest do
  use ApiWeb.ConnCase, async: true

  import Mox

  alias FinancialSystem.Core

  setup :verify_on_exit!

  describe "POST /api/authenticate" do
    test "when params are valid, should return 201 and the token", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "qwauhqqqw@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      params = %{email: "qwauhqqqw@gmail.com", password: "fp3@naDSsjh2"}

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/accounts/authenticate", params)
        |> json_response(201)

      token_length = String.length(response["token"])
      expected_length = 64

      assert token_length == expected_length
    end

    test "when password and email dont match, should return a message", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "qwauhqqqw@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      params = %{email: "qwauhqqqw@gmail.com", password: "f3@naDSsjh2"}

      %{"error" => response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/accounts/authenticate", params)
        |> json_response(422)

      error = "invalid_email_or_password"

      assert ^response = error
    end

    test "when user dont exist, shoulg return a message", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "qwauhqqqw@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      params = %{email: "qauhqqqw@gmail.com", password: "fp3@naDSsjh2"}

      %{"error" => response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/accounts/authenticate", params)
        |> json_response(422)

      error = "user_dont_exist"

      assert ^response = error
    end

    test "when password is in invalid type, shoulg return a message", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "qwauhqqqw@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      params = %{email: "qwauhqqqw@gmail.com", password: 12_345_678}

      %{"error" => response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/accounts/authenticate", params)
        |> json_response(422)

      error = "invalid_password_type"

      assert ^response = error
    end
  end

  describe "POST /api/accounts" do
    test "when params are valid, should return 201", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      params = %{
        role: "regular",
        name: "Yashin",
        currency: "brl",
        value: "100",
        email: "yaxxxxxshin@gmail.com",
        password: "fp3@naDSsjh2"
      }

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/accounts", params)
        |> json_response(201)

      expected = %{
        "account" => %{
          "currency" => "BRL",
          "id" => response["account"]["id"],
          "value" => 10_000
        }
      }

      assert response == expected
    end

    test "when params are not valid, should return 422", %{conn: conn} do
      params = %{
        name: "Yashin",
        currency: "brl",
        email: "yaxxxxxshin@gmail.com",
        password: "fp3@naDSsjh2"
      }

      %{"error" => response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/accounts", params)
        |> json_response(422)

      error = "invalid_arguments"

      assert ^response = error
    end

    test "when currency dont exist, should return 422", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      params = %{
        role: "regular",
        name: "Yashin",
        currency: "bbrl",
        value: "100",
        email: "yaxxxxxshin@gmail.com",
        password: "fp3@naDSsjh2"
      }

      %{"error" => response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/accounts", params)
        |> json_response(422)

      error = "currency_is_not_valid"

      assert ^response = error
    end

    test "when name has less than 2 character, should return 400", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      params = %{
        role: "regular",
        name: "Y",
        currency: "brl",
        value: "100",
        email: "yaxxxxxshin@gmail.com",
        password: "fp3@naDSsjh2"
      }

      %{"error" => response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/accounts", params)
        |> json_response(422)

      error = %{"name" => ["should be at least 2 character(s)"]}

      assert ^response = error
    end

    test "when params is not valid, should return 400", %{conn: conn} do
      params = %{
        role: "regular",
        name: "Yashin",
        currency: "brl",
        value: 100,
        email: "yashvvvvin@gmail.com",
        password: "Fp3@nasjh2"
      }

      %{"error" => response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/accounts", params)
        |> json_response(400)

      error = "invalid_value_type"

      assert ^response = error
    end
  end

  describe "DELETE /api/accounts/:id" do
    test "when params are valid, should return 200", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {:ok, account} =
        Core.create(%{
          "name" => "Yashin",
          "currency" => "brl",
          "value" => "100",
          "email" => "yashfffffffin@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      {:ok, token} =
        Core.authenticate(%{"email" => "yashfffffffin@gmail.com", "password" => "fp3@naDSsjh2"})

      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> delete("/api/accounts/" <> account.id)
        |> json_response(201)

      expected = %{"msg" => "account_deleted"}

      assert response == expected
    end
  end
end
