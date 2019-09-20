defmodule ContactRepositoryTest do
  use FinancialSystem.Core.DataCase, async: true

  import Mox

  alias FinancialSystem.Core.Contacts.ContactRepository

  setup :verify_on_exit!

  doctest FinancialSystem.Core.Contacts.ContactRepository

  describe "create_contact/1" do
    test "Should be able to create a contact" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} =
        FinancialSystem.Core.create(%{
          "role" => "regular",
          "name" => "Yashin Santos",
          "currency" => "BRL",
          "value" => "1",
          "email" => "test@gmaxxil.com",
          "password" => "f1aA678@"
        })

      {:ok, contact} =
        ContactRepository.create_contact(%{
          "account_id" => account.id,
          "email" => "test@gmaxxil.com",
          "nickname" => "test"
        })

      %{nickname: nickname, email: email} = contact

      assert nickname == "test"
      assert email == "test@gmaxxil.com"
    end

    test "Should be able to create the same contact twice" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} =
        FinancialSystem.Core.create(%{
          "role" => "regular",
          "name" => "Yashin Santos",
          "currency" => "BRL",
          "value" => "1",
          "email" => "test@gmaxxil.com",
          "password" => "f1aA678@"
        })

      ContactRepository.create_contact(%{
        "account_id" => account.id,
        "email" => "test@gmaxxil.com",
        "nickname" => "test"
      })

      {:error, error} =
        ContactRepository.create_contact(%{
          "account_id" => account.id,
          "email" => "test@gmaxxil.com",
          "nickname" => "test"
        })

      assert error == :already_in_contacts
    end

    test "Should not be able to create a contact with invalid email" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} =
        FinancialSystem.Core.create(%{
          "role" => "regular",
          "name" => "Yashin Santos",
          "currency" => "BRL",
          "value" => "1",
          "email" => "test@gmaxxil.com",
          "password" => "f1aA678@"
        })

      {:error, error} =
        ContactRepository.create_contact(%{
          "account_id" => account.id,
          "email" => 1,
          "nickname" => "test"
        })

      assert error == :invalid_email_type
    end
  end

  describe "get_contact/1" do
    test "Should be able to search a contact" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} =
        FinancialSystem.Core.create(%{
          "role" => "regular",
          "name" => "Yashin Santos",
          "currency" => "BRL",
          "value" => "1",
          "email" => "test@gmaxxil.com",
          "password" => "f1aA678@"
        })

      ContactRepository.create_contact(%{
        "account_id" => account.id,
        "email" => "test@gmaxxil.com",
        "nickname" => "test"
      })

      {:ok, contact} =
        ContactRepository.get_contact(%{"account_id" => account.id, "email" => "test@gmaxxil.com"})

      %{nickname: nickname, email: email} = contact

      assert nickname == "test"
      assert email == "test@gmaxxil.com"
    end

    test "Should not be able to search a contact if insert a inexistent user" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} =
        FinancialSystem.Core.create(%{
          "role" => "regular",
          "name" => "Yashin Santos",
          "currency" => "BRL",
          "value" => "1",
          "email" => "test@gmaxxil.com",
          "password" => "f1aA678@"
        })

      ContactRepository.create_contact(%{
        "account_id" => account.id,
        "email" => "test@gmaxxil.com",
        "nickname" => "test"
      })

      {:error, error} =
        ContactRepository.get_contact(%{"account_id" => account.id, "email" => "testgmaxxil.com"})


      assert error == :user_dont_exist
    end
  end
end
