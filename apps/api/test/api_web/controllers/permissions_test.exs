defmodule ApiWeb.PermissionsTest do
  use ApiWeb.ConnCase, async: true

  import Mox

  alias FinancialSystem.Core
  alias FinancialSystem.Core.Accounts.Account
  alias FinancialSystem.Core.Users.User

  describe "POST" do
    test "When is a admin user, can do the action", %{conn: conn} do
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

      {_, account} =
        Core.create(%{
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

    test "when not is a admin user, cannot do the action in others accounts", %{conn: conn} do
      expect(CurrencyMock, :currency_is_valid, 2, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      Core.create(%{
        "name" => "Yashin",
        "currency" => "brl",
        "value" => "100",
        "email" => "qqxwqw@gmail.com",
        "password" => "fp3@naDSsjh2"
      })

      {_, account} =
        Core.create(%{
          "name" => "Yashin",
          "currency" => "brl",
          "value" => "100",
          "email" => "cqwqw@gmail.com",
          "password" => "fp3@naDSsjh2"
        })

      Core.withdraw(%{
        "account_id" => account.id,
        "value" => "10"
      })

      {:ok, token} =
        Core.authenticate(%{"email" => "qqxwqw@gmail.com", "password" => "fp3@naDSsjh2"})

      %{"message" => response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", token)
        |> get("/api/operations/financial_statement/" <> "cqwqw@gmail.com")
        |> json_response(401)

      error = "unauthorized"

      assert ^response = error
    end
  end
end
