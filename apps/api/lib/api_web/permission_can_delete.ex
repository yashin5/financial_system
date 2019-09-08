defmodule ApiWeb.PermissionCanDelete do
  @moduledoc """
  This module is a Plug responsable to make the authorization in a router pipeline.
  """

  import Plug.Conn

  alias FinancialSystem.Core.Permissions.PermissionRepository

  def init(options \\ []), do: options

  def call(conn, _options) do
    with {:ok, true} <-
           PermissionRepository.can_do_this_action(
            %{permission: :can_delete, role: conn.assigns[:role]}
           ) do
      conn
    else
      _ -> send_resp(conn, 401, Jason.encode!(%{message: "unauthorized"}))
    end
  end
end
