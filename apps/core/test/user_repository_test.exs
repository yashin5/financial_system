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

    test "Should not create a new user if pass a invalid email" do
      {:error, user} = UserRepository.new_user("Yaxx", "yaxx.com", "X@ghnx1234")

      user_errors = user.errors

      error = [{:email, {"has invalid format", [validation: :format]}}]

      assert user_errors == error
    end

    test "Should not create a new user if pass a invalid email type" do
      {:error, user} = UserRepository.new_user("Yaxx", 11, "X@ghnx1234")

      user_errors = user.errors

      error = [{:email, {"is invalid", [type: :string, validation: :cast]}}]

      assert user_errors == error
    end

    test "Should not create a new user if pass a invalid name" do
      {:error, user} = UserRepository.new_user("Y", "yaxx@g.com", "X@ghnx1234")

      user_errors = user.errors

      error = [
        {:name,
         {"should be at least %{count} character(s)",
          [count: 2, validation: :length, kind: :min, type: :string]}}
      ]

      assert user_errors == error
    end

    test "Should not create a new user if pass a invalid name type" do
      {:error, user} = UserRepository.new_user(12, "yaxx@g.com", "X@ghnx1234")

      user_errors = user.errors

      error = [{:name, {"is invalid", [type: :string, validation: :cast]}}]

      assert user_errors == error
    end

    test "Should not create a new user if pass a invalid password" do
      {:error, user} = UserRepository.new_user("Yaxx", "yaxx@g.com", "X@23")

      user_errors = user.errors

      error = [
        {:password,
         {"should be at least %{count} character(s)",
          [count: 6, validation: :length, kind: :min, type: :string]}}
      ]

      assert user_errors == error
    end

    test "Should not create a new user if pass a invalid password type" do
      {:error, user} = UserRepository.new_user("Yaxx", "yaxx@g.com", 1)

      user_errors = user.errors

      error = [password: {"is invalid", [type: :string, validation: :cast]}]

      assert user_errors == error
    end

    test "Should not create a new user if pass a invalid password length" do
      {:error, user} = UserRepository.new_user("Yaxx", "yaxx@g.com", "X@")

      user_errors = user.errors

      error = [
        {:password,
         {"should be at least %{count} character(s)",
          [count: 6, validation: :length, kind: :min, type: :string]}}
      ]

      assert user_errors == error
    end
  end

  describe "authenticate/2" do
    test "Should be able to authenticate if pass data from existent user" do
      UserRepository.new_user("Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      {:ok, authenticate} =
        UserRepository.authenticate(%{"email" => "yaxx@gmailsx.com", "password" => "X@ghnx1234"})

      token_length = authenticate |> String.length()
      supose_to_be_length = 64

      assert token_length == supose_to_be_length
    end

    test "Should not be able to authenticate if pass data from unexistent user" do
      authenticate =
        UserRepository.authenticate(%{"email" => "yaxx@gmailsx.com", "password" => "X@ghnx1234"})

      error = {:error, :user_dont_exist}

      assert authenticate == error
    end

    test "Should not be able to authenticate if pass invalid email type" do
      authenticate = UserRepository.authenticate(%{"email" => 1, "password" => "X@ghnx1234"})

      error = {:error, :invalid_email_type}

      assert authenticate == error
    end

    test "Should not be able to authenticate if pass invalid password type" do
      authenticate = UserRepository.authenticate(%{"email" => "yaxx@g.xom", "password" => 1})

      error = {:error, :invalid_password_type}

      assert authenticate == error
    end
  end

  describe "get_user/2" do
    test "Should be able to get user informations if pass a existent user email" do
      UserRepository.new_user("Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      {:ok, user} = UserRepository.get_user(:auth, "yaxx@gmailsx.com")

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

    test "Should not be able to get user informations if pass a unexistent user email" do
      user = UserRepository.get_user(:auth, "yaxx@gmailsx.comm")
      error = {:error, :user_dont_exist}

      assert user == error
    end

    test "Should not be able to get user informations if pass a invalid email type" do
      user = UserRepository.get_user(:auth, 1)

      error = {:error, :invalid_email_type}

      assert user == error
    end
  end

  describe "get_user/1" do
    test "Should be able to get user informations if pass a existent id of user" do
      {:ok, new_user} = UserRepository.new_user("Yaxx", "yaxx@gmailsx.com", "X@ghnx1234")

      {:ok, user} = UserRepository.get_user(new_user.id)

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

    test "Should not be able to get user informations if pass a unexistent id" do
      user = UserRepository.get_user(UUID.uuid4())
      error = {:error, :user_dont_exist}

      assert user == error
    end

    test "Should not be able to get user informations if pass a invalid email type" do
      user = UserRepository.get_user(123)

      error = {:error, :invalid_id_type}

      assert user == error
    end
  end
end
