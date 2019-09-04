defmodule FinancialSystem.Core.Roles.RoleRepository do
  alias FinancialSystem.Core.Repo
  alias FinancialSystem.Core.Roles.Role

  def get_role(:all), do: Role |> Repo.all()

  def get_role(role) do
    Role
    |> Repo.get_by(role: role)
  end
end
