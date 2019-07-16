defmodule FinancialSystem.DataCase do
  @moduledoc false
  use ExUnit.CaseTemplate
  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      alias FinancialSystem.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import FinancialSystem.DataCase
    end
  end

  setup tags do
    :ok = Sandbox.checkout(FinancialSystem.Repo)

    unless tags[:async] do
      Sandbox.mode(FinancialSystem.Repo, {:shared, self()})
    end

    :ok
  end
end
