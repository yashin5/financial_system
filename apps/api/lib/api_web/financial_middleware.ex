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
    |> make_params_to_split()
    |> do_make_split()
  end

  defp do_make_split(%{"split_list" => {:error, _} = error}) do
    error
  end

  defp do_make_split(split_list) do
    Core.split(split_list)
  end

  defp make_params_to_split(list) do
    list
    |> Map.put(
      "split_list",
      list["split_list"]
      |> Enum.reduce_while([], &make_split_list(&1, &2))
    )
  end

  defp make_split_list(item, acc) do
    :account
    |> Helpers.get_account_or_user(:email, item)
    |> do_make_split_list({item, acc})
  end

  defp do_make_split_list({:ok, account}, {item, acc}) do
    {:cont, [%Split{account: account.id, percent: item["percent"]} | acc]}
  end

  defp do_make_split_list(error, _) do
    {:halt, error}
  end
end
