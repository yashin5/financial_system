defmodule FinancialSystem.Core.Permissions.PermissionRepository do
  alias FinancialSystem.Core.Permissions.Permission
  alias FinancialSystem.Core.Repo
  alias FinancialSystem.Core.Roles.RoleRepository

  def can_do_this_action(:can_create, role) do
    role_data = RoleRepository.get_role(role)

    get_permission(role_data.id)
    |> can?(:can_create)
  end

  def can_do_this_action(:can_view, role) do
    {:ok, role_data} = RoleRepository.get_role(role)

    get_permission(role_data.id)
    |> can?(:can_view)
  end

  def can_do_this_action(:can_delete, role) do
    {:ok, role_data} = RoleRepository.get_role(role)

    get_permission(role_data.id)
    |> can?(:can_delete)
  end

  def can_do_this_action(:can_view_all, role) do
    {:ok, role_data} = RoleRepository.get_role(role)

    get_permission(role_data.id)
    |> can?(:can_view_all)
  end

  defp get_permission(role_id), do: Permission |> Repo.get_by!(role_id: role_id)

  defp can?(%Permission{} = permissions, action) do
    Map.get(permissions, action) == true
  end
end
