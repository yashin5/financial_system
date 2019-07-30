defmodule ApiWeb.AccountsView do
  use ApiWeb, :view

  def render("create.json", %{account: response}) do
    %{
      account: response,
      response_status: 201
    }
  end
end
