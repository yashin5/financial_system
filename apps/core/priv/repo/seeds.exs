defmodule FinancialSystem.Core.Repo.Seeds do
  alias FinancialSystem.Core.Accounts.Account
  alias FinancialSystem.Core.Permissions.Permission
  alias FinancialSystem.Core.Repo
  alias FinancialSystem.Core.Roles.Role
  alias FinancialSystem.Core.Users.User

  admin_role =
    %Role{}
    |> Role.changeset(%{role: "admin"})
    |> Repo.insert!()

  admin_permission = %{
    can_view: true,
    can_create: true,
    can_delete: true,
    can_view_all: true
  }

  admin_role
  |> Ecto.build_assoc(:permission, admin_permission)
  |> Permission.changeset(admin_permission)
  |> Repo.insert!()

  regular_role =
    %Role{}
    |> Role.changeset(%{role: "regular"})
    |> Repo.insert!()

  regular_permission = %{
    can_view: true,
    can_create: true,
    can_delete: true,
    can_view_all: false
  }

  regular_role
  |> Ecto.build_assoc(:permission, regular_permission)
  |> Permission.changeset(regular_permission)
  |> Repo.insert!()

  {:ok, super_user} =
    %User{}
    |> User.changeset(%{
      role: "admin",
      name: "Yashin",
      email: "qqwqw@gmail.com",
      password: "fp3@naDSsjh2"
    })
    |> Repo.insert()

  super_user
  |> Ecto.build_assoc(:account, %{})
  |> Account.changeset(%{
    active: true,
    currency: "BRL",
    value: "10000"
  })
  |> Repo.insert()
end
