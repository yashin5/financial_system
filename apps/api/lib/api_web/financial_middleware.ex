defmodule ApiWeb.FinancialMiddleware do
  alias FinancialSystem.Core
  alias FinancialSystem.Core.Split
  alias FinancialSystem.Core.Users.UserRepository
  alias FinancialSystem.Core.Accounts.AccountRepository

  def make_transfer(params) do
    with {:ok, account_id} <- get_account_id(params),
         params_with_accountto <- Map.put(params, "account_to", account_id) do
      Core.transfer(params_with_accountto)
    end
  end

  def make_split(list) do
    list
    |> make_split_list
    |> Core.split()
  end

  defp make_split_list(list) do
    list
    |> Map.put(
      "split_list",
      list["split_list"]
      |> Enum.map(fn item ->
        {:ok, account_id} = get_account_id(item)

        %Split{account: account_id, percent: item["percent"]}
      end)
    )
  end

  defp get_account_id(%{"email" => email}) do
    with {:ok, user} <- UserRepository.get_user(%{email: email}),
         {:ok, account} <- AccountRepository.find_account(:userid, user.id) do
      {:ok, account.id}
    end
  end
end
