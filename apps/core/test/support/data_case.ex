defmodule FinancialSystem.Core.DataCase do
  @moduledoc false
  use ExUnit.CaseTemplate
  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      alias FinancialSystem.Core.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import FinancialSystem.Core.DataCase
    end
  end

  setup tags do
    :ok = Sandbox.checkout(FinancialSystem.Core.Repo)

    unless tags[:async] do
      Sandbox.mode(FinancialSystem.Core.Repo, {:shared, self()})
    end

    :ok
  end
end
