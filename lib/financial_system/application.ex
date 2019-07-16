defmodule FinancialSystem.Application do
  @moduledoc """
  This module is responsable to start the process :register_account.
  """

  use Application

  alias FinancialSystem.Repo
<<<<<<< HEAD
=======
  alias FinancialSystemWeb.API.Router
>>>>>>> api/updates

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
<<<<<<< HEAD
      worker(Repo, [])
=======
      worker(Repo, []),
      {Plug.Cowboy, scheme: :http, plug: Router, options: [port: 8080]}
>>>>>>> api/updates
    ]

    opts = [strategy: :one_for_one, name: FinancialSystem.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
