defmodule FinancialSystem.Core.Roles.RoleRepository do
  @moduledoc """
    This module is responsable to get role
  """

  alias FinancialSystem.Core.Repo
  alias FinancialSystem.Core.Roles.Role

  def get_role(role) do
    Role
    |> Repo.get_by(role: role)
  end
end
