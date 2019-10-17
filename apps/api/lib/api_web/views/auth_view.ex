defmodule ApiWeb.AuthView do
  use ApiWeb, :view

  def render("validate_token.json", %{validate_token: response}) do
    %{
      is_valid: response
    }
  end
end
