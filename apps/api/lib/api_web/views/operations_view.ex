defmodule ApiWeb.OperationsView do
  use ApiWeb, :view

  def render("deposit.json", %{deposit: deposit}) do
    %{
      account_id: deposit.id,
      response_status: 201,
      new_balance: deposit.value
    }
  end
end
