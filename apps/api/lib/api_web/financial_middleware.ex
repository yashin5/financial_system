defmodule ApiWeb.FinancialMiddleware do
  @moduledoc """
    handles parameters to call core functions
  """
  alias FinancialSystem.Core
  alias FinancialSystem.Core.Helpers
  alias FinancialSystem.Core.Split

  def make_transfer(params) do
    with {:ok, account} <- Helpers.get_account_or_user(:account, :email, params),
         params_with_accountto <- Map.put(params, "account_to", account.id) do
      Core.transfer(params_with_accountto)
    end
  end

  def make_split(params) do
    params
    |> make_split_list
    |> Core.split()
  end

  defp make_split_list(list) do
    list
    |> Map.put(
      "split_list",
      list["split_list"]
      |> Enum.map(fn item ->
        {:ok, account} = Helpers.get_account_or_user(:account, :email, item)

        %Split{account: account.id, percent: item["percent"]}
      end)
    )
  end
end
