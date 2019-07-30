defmodule ApiWeb.AccountsView do
  use ApiWeb, :view

  def render("create.json", %{create: response}) do
    %{
      account: response,
      response_status: 201
    }
  end

  def render("delete.json", %{delete: response}) do
    %{
      msg: response,
      response_status: 201
    }
  end
end
