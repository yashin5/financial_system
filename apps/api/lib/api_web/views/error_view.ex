defmodule ApiWeb.ErrorView do
  use ApiWeb, :view

  def render("error.json", %{error: msg}) do
    %{error: msg}
  end
end
