defmodule FinancialSystem.Core.Permissions.PermissionRepository do
  @moduledoc """
    This module is responsable to validate the permission
  """

  alias FinancialSystem.Core.Permissions.Permission
  alias FinancialSystem.Core.Repo
  alias FinancialSystem.Core.Roles.RoleRepository

  def can_do_this_action(%{permission: permission, role: role})
      when role in ["admin", "regular"] and
             permission in [:can_create, :can_delete, :can_view, :can_view_all] do
    {:ok, do_can_do_this_action?(permission, role)}
  end

  def can_do_this_action(%{permission: permission, role: role})
      when permission in [:can_create, :can_delete, :can_view, :can_view_all] and
             role not in ["admin", "regular"] do
    {:error, :invalid_role}
  end

  def can_do_this_action(%{permission: permission, role: role})
      when role in ["admin", "regular"] and
             permission not in [:can_create, :can_delete, :can_view, :can_view_all] do
    {:error, :invalid_permission}
  end

  def can_do_this_action(%{permission: permission, role: role})
      when role not in ["admin", "regular"] and
             permission not in [:can_create, :can_delete, :can_view, :can_view_all] do
    {:error, :invalid_role_and_permission}
  end

  defp do_can_do_this_action?(:can_create, role) do
    role_data = RoleRepository.get_role(role)

    role_data.id
    |> get_permission()
    |> can?(:can_create)
  end

  defp do_can_do_this_action?(:can_view, role) do
    role_data = RoleRepository.get_role(role)

    role_data.id
    |> get_permission()
    |> can?(:can_view)
  end

  defp do_can_do_this_action?(:can_delete, role) do
    role_data = RoleRepository.get_role(role)

    role_data.id
    |> get_permission()
    |> can?(:can_delete)
  end

  defp do_can_do_this_action?(:can_view_all, role) do
    role_data = RoleRepository.get_role(role)

    role_data.id
    |> get_permission()
    |> can?(:can_view_all)
  end

  defp get_permission(role_id), do: Permission |> Repo.get_by!(role_id: role_id)

  defp can?(%Permission{} = permissions, action) do
    Map.get(permissions, action) == true
  end
end
