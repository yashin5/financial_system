defmodule FinancialSystem.Core.Helpers do
  @moduledoc """
    Help to get user and account with base in email and account_id
  """

  alias FinancialSystem.Core.Accounts.Account
  alias FinancialSystem.Core.Accounts.AccountRepository
  alias FinancialSystem.Core.Users.User
  alias FinancialSystem.Core.Users.UserRepository

  @spec get_account_or_user(
          :user | :account,
          :account_id | :email,
          %{account_id: String.t()} | %{email: String.t()}
        ) ::
          {:ok, User.t() | Account.t()} | {:error, atom()}
  def get_account_or_user(:user, :account_id, %{"account_id" => account_id}) do
    get_account_or_user(:user, :account_id, account_id)
  end

  def get_account_or_user(:account, :email, %{"email" => email}) do
    get_account_or_user(:account, :email, email)
  end

  def get_account_or_user(:account, :email, email) do
    with {:ok, user} <- UserRepository.get_user(%{email: email}),
         {:ok, account} <- AccountRepository.find_account(:userid, user.id) do
      {:ok, account}
    end
  end

  def get_account_or_user(:user, :account_id, account_id) do
    with {:ok, account} <- AccountRepository.find_account(:accountid, account_id),
         {:ok, user} <- UserRepository.get_user(%{user_id: account.user_id}) do
      {:ok, user}
    end
  end
end
