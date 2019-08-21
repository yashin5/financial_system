defmodule TokenRepositoryTest do
  use FinancialSystem.Core.DataCase, async: true

  import Mox

  alias FinancialSystem.Core.Tokens.TokenRepository

  setup :verify_on_exit!

  doctest FinancialSystem.Core.Tokens.TokenRepository

  describe "generate_token/1" do
    test "Should be able to create a token for an existent user" do
      {:ok, user} =
        FinancialSystem.Core.Users.UserRepository.new_user(
          "Yxcaxx",
          "yaxx@gmailsx.com",
          "X@ghnx1234"
        )

      {:ok, token} = TokenRepository.generate_token(user.id)

      token_length = token |> String.length()

      expected_length = 64

      assert token_length == expected_length
    end

    test "Should not be able to create a token for an unexistent user" do
      token = TokenRepository.generate_token(UUID.uuid4())

      error = {:error, :user_dont_exist}

      assert token == error
    end

    test "Should not be able to create a token if insert a invalid id type" do
      token = TokenRepository.generate_token(12)

      error = {:error, :invalid_id_type}

      assert token == error
    end
  end

  describe "validate_token/1" do
    test "Should be able to verify if token is valid if insert a valid token" do
      {:ok, user} =
        FinancialSystem.Core.Users.UserRepository.new_user(
          "Yxcaxx",
          "yasdxx@gmailsx.com",
          "X@ghnx1234"
        )

      {:ok, token} =
        FinancialSystem.Core.authenticate(
          "yasdxx@gmailsx.com",
          "X@ghnx1234"
        )

      assert {:ok, user.id} == TokenRepository.validate_token(token)
    end

    test "Should not be able to verify if token is valid if insert a invalid token" do
      {:error, token_validated} =
        TokenRepository.validate_token(
          "aasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasasdasadasdas"
        )

      assert token_validated == :token_dont_exist
    end

    test "Should not be able to verify if token is valid if insert a invalid token type" do
      {:error, token_validated} = TokenRepository.validate_token(123)

      assert token_validated == :invalid_token_type
    end
  end
end
