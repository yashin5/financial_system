defmodule FinancialSystem.ApiTest do
  use FinancialSystem.ConnCase, async: true

  describe "POST /accounts/create" do
    test "when params are invalid, should return 400" do
      params = %{}
      response = conn(:post, "/accounts/create", params)
      assert response == true
    end

    test "when params are valid, should return 200" do
      params = %{}
      response = conn(:post, "/accounts/create", params)
    end
  end
end
