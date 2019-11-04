  alias FinancialSystem.Core.Accounts.Account
  alias FinancialSystem.Core.Helpers
  alias FinancialSystem.Core.Permissions.Permission
  alias FinancialSystem.Core.Repo
  alias FinancialSystem.Core.Roles.Role
  alias FinancialSystem.Core.Users.User

  conflict_options = fn fields ->
    [conflict_target: fields, on_conflict: :nothing]
  end

  create_super_user = fn ->
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


  admin_role =
    %Role{}
    |> Role.changeset(%{role: "admin"})
    |> Repo.insert!(conflict_options.([:role]))

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
    |> Repo.insert!(conflict_options.([:role]))

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
end

case Helpers.get_account_or_user(:account, :email, %{"email" => "qqwqw@gmail.com"}) do
  {:ok, _} -> :ok
  {:error, _} -> create_super_user.()
end

