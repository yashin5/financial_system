defmodule ApiWeb.AuthTest do
  use ApiWeb.ConnCase, async: true

  import Mox

  describe "POST" do
    test "When token is valid, return true" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {:ok, account} =
        FinancialSystem.Core.create("Yashin", "brl", "122", "email@gmail.com", "Y@ashin4321")

      {:ok, token} = FinancialSystem.Core.authenticate("email@gmail.com", "Y@ashin4321")

      params = %{account_id: account.id, value: "100"}

      conn =
        build_conn()
        |> put_req_header("autorization", token)
        |> post("/api/operations/withdraw", params)
        |> json_response(201)

      expected = %{"error" => "account_dont_exist"}

      assert conn == expected
    end
  end
end
