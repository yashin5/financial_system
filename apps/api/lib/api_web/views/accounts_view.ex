defmodule ApiWeb.AccountsView do
  use ApiWeb, :view

  def render("create.json", %{create: response}) do
    %{
      account: response
    }
  end

  def render("delete.json", %{delete: response}) do
    %{
      msg: response
    }
  end
end
