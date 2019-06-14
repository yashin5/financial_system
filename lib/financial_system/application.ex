defmodule FinancialSystem.Application do
  @moduledoc """
  This module is responsable to start the process :register_account.
  """

  use Application

  alias FinancialSystem.Repo
  alias Routes.IndexPlug

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Repo, []),
      {Plug.Cowboy, scheme: :http, plug: IndexPlug, options: [port: 8080]}
    ]

    opts = [strategy: :one_for_one, name: FinancialSystem.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
