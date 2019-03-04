defmodule CreateAccount do
  use ExUnit.Case
  doctest FinancialSystem.CreateAccount

  test "create user" do
    assert FinancialSystem.CreateAccount.create_user("This", "is", "brl", 100)
  end
end
