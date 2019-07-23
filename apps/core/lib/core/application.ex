defmodule FinancialSystem.Core.Application do
  @moduledoc """
  This module is responsable to start the process :register_account.
  """

  use Application

  alias FinancialSystem.Core.Repo

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Repo, [])
    ]

    opts = [strategy: :one_for_one, name: FinancialSystem.Core.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
