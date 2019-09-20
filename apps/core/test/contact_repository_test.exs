defmodule ContactRepositoryTest do
  use FinancialSystem.Core.DataCase, async: true

  import Mox

  alias FinancialSystem.Core

  setup :verify_on_exit!

  doctest FinancialSystem.Core.Contacts.ContactRepository

  describe "create_contact/1" do
    test "Should be able to create a contact" do
      expect(CurrencyMock, :currency_is_valid, fn currency ->
        {:ok, String.upcase(currency)}
      end)

      {_, account} =
        Core.create(%{
          "role" => "regular",
          "name" => "Yashin Santos",
          "currency" => "BRL",
          "value" => "1",
          "email" => "test@gmaxxil.com",
          "password" => "f1aA678@"
        })

      {:ok, contact} =
        Core.create_contact(%{
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

      Core.create_contact(%{
        "account_id" => account.id,
        "email" => "test@gmaxxil.com",
        "nickname" => "test"
      })

      {:error, error} =
        Core.create_contact(%{
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
        Core.create_contact(%{
          "account_id" => account.id,
          "email" => 1,
          "nickname" => "test"
        })

      assert error == :invalid_email_type
    end
  end

  describe "get_all_contacts/1" do
    test "Should be able to get the contacts" do
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

      Core.create_contact(%{
        "account_id" => account.id,
        "email" => "test@gmaxxil.com",
        "nickname" => "test"
      })

      {:ok, [contact | _]} = Core.get_all_contacts(%{"account_id" => account.id})

      %{nickname: nickname, email: email} = contact

      assert nickname == "test"
      assert email == "test@gmaxxil.com"
    end

    test "Should not be able to search a contact if insert a invalid email type" do
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

      Core.create_contact(%{
        "account_id" => account.id,
        "email" => "test@gmaxxil.com",
        "nickname" => "test"
      })

      {:error, error} = Core.get_all_contacts(%{"account_id" => UUID.uuid4()})

      assert error == :account_dont_exist
    end

    test "Should  be able to search a contact if insert a invalid account id" do
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

      Core.create_contact(%{
        "account_id" => account.id,
        "email" => "test@gmaxxil.com",
        "nickname" => "test"
      })

      {:error, error_account} = Core.get_all_contacts(%{"account_id" => 1})

      assert error_account == :invalid_account_id_type
    end
  end

  describe "update_contact_nickname/1" do
    test "Should be able to update the contact nickname" do
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

      Core.create_contact(%{
        "account_id" => account.id,
        "email" => "test@gmaxxil.com",
        "nickname" => "test"
      })

      {:ok, contact_actualized} =
        Core.update_contact_nickname(%{
          "account_id" => account.id,
          "email" => "test@gmaxxil.com",
          "new_nickname" => "testt"
        })

      assert contact_actualized.nickname == "testt"
    end

    test "Should not be able to update the contact nickname to the same" do
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

      Core.create_contact(%{
        "account_id" => account.id,
        "email" => "test@gmaxxil.com",
        "nickname" => "test"
      })

      {:error, error} =
        Core.update_contact_nickname(%{
          "account_id" => account.id,
          "email" => "test@gmaxxil.com",
          "new_nickname" => "test"
        })

      assert error == :contact_actual_name
    end
  end
end
