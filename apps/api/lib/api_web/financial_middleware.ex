defmodule ApiWeb.FinancialMiddleware do
  alias FinancialSystem.Core
  alias FinancialSystem.Core.Users.UserRepository
  alias FinancialSystem.Core.Accounts.AccountRepository

  def make_transfer(%{"email" => email} = params) do
    with {:ok, user} <- UserRepository.get_user(%{email: email}),
         {:ok, account} <- AccountRepository.find_account(:userid, user.id),
         params_with_accountto <- Map.put(params, "account_to", account.id) do
      Core.transfer(params_with_accountto)
    end
  end
end
