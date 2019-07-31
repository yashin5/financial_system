defmodule ApiWeb.ErrorView do
  use ApiWeb, :view

  def render("error.json", %{msg: msg}) do
    %{error: msg}
  end
end
