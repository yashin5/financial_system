defmodule FinancialSystem.Core.Users.UserRepository do
  alias FinancialSystem.Core.Users.User
  alias FinancialSystem.Core.Repo

  def new_user(name, email, password) do
    name
    |> new(email, password)
    |> do_new_user()
  end

  defp do_new_user(user) do
    %User{}
    |> User.changeset(user)
    |> Repo.insert()
  end

  defp new(name, email, password) do
    %{name: name, email: email, password: password}
  end
end
