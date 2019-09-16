defmodule PermissionRepositoryTest do
  use FinancialSystem.Core.DataCase, async: true

  import Mox

  alias FinancialSystem.Core.Permissions.PermissionRepository

  setup :verify_on_exit!

  doctest FinancialSystem.Core.Permissions.PermissionRepository

  describe "can_do_this_action/2" do
    test "validate the permission with base in role" do
      can_create =
        PermissionRepository.can_do_this_action(%{permission: :can_create, role: "regular"})

      can_delete =
        PermissionRepository.can_do_this_action(%{permission: :can_delete, role: "regular"})

      can_view =
        PermissionRepository.can_do_this_action(%{permission: :can_view, role: "regular"})

      can_view_all =
        PermissionRepository.can_do_this_action(%{permission: :can_view_all, role: "regular"})

      assert can_create == {:ok, true}
      assert can_delete == {:ok, true}
      assert can_view == {:ok, true}
      assert can_view_all == {:ok, false}
    end

    test "should not be able to validate if insert a invalid role" do
      {:error, invalid_role} =
        PermissionRepository.can_do_this_action(%{permission: :can_create, role: "rregular"})

      error = :invalid_role

      assert invalid_role == error
    end

    test "should not be able to validate if insert a invalid permission" do
      {:error, invalid_permission} =
        PermissionRepository.can_do_this_action(%{permission: :not_create, role: "regular"})

      error = :invalid_permission

      assert invalid_permission == error
    end

    test "should not be able to validate if insert a invalid permission and role" do
      {:error, invalid_permission_role} =
        PermissionRepository.can_do_this_action(%{permission: :not_create, role: "rsegular"})

      error = :invalid_role_and_permission

      assert invalid_permission_role == error
    end
  end
end
