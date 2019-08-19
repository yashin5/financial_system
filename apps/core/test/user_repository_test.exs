defmodule UserRepositoryTest do
  use FinancialSystem.Core.DataCase, async: true

  import Mox

  alias FinancialSystem.Core.Users.UserRepository

  setup :verify_on_exit!

  doctest FinancialSystem.Core.Users.UserRepository

  describe "new_user/3" do
    test "Should create a new user if pass correct params" do
      {:ok, user} = UserRepository.new_user("Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      user_simulate = %{
        email: "yaxx@gmailsx.com",
        id: user.id,
        name: "Yaxx",
        password_hash: user.password_hash
      }

      user_struct = %{
        email: user.email,
        id: user.id,
        name: user.name,
        password_hash: user.password_hash
      }

      assert user_simulate == user_struct
    end
  end
end
