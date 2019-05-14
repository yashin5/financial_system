defmodule FinancialSystem.Application do
  use Application

  alias FinancialSystem.AccountState

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(AccountState, [])
    ]

    opts = [strategy: :one_for_one, name: FinancialSystem.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
