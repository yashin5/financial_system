defmodule TokenRepositoryTest do
  use FinancialSystem.Core.DataCase, async: true

  import Mox

  alias FinancialSystem.Core.Tokens.TokenRepository

  setup :verify_on_exit!

  doctest FinancialSystem.Core.Tokens.TokenRepository

  test "Should be able to create a token for an existent user" do
    {:ok, user} =
      FinancialSystem.Core.Users.UserRepository.new_user(
        "Yxcaxx",
        "yaxx@gmailsx.com",
        "X@ghnx1234"
      )

    {:ok, token} = TokenRepository.generate_token(user.id)

    token_length = token |> String.length()

    suposed_to_be_length = 64

    assert token_length == suposed_to_be_length
  end

  test "Should not be able to create a token for an unexistent user" do
    token = TokenRepository.generate_token(UUID.uuid4())

    error = {:error, :user_dont_exist}

    assert token == error
  end
end
