defmodule FinancialSystemTest do
  use ExUnit.Case
  doctest FinancialSystem

  test "greets the world" do
    assert FinancialSystem.hello() == :world
  end
end
