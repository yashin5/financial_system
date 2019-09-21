defmodule FinancialSystem.Core.Helpers do
  alias FinancialSystem.Core.Users.UserRepository
  alias FinancialSystem.Core.Accounts.AccountRepository

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
