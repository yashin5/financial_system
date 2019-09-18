defmodule ApiWeb.Permissions do
  @moduledoc """
  This module is a Plug responsable to make the authorization in a router pipeline.
  """

  import Plug.Conn

  alias FinancialSystem.Core.Permissions.PermissionRepository

  def init(options \\ []), do: options

  def call(conn, options) do
    with {:ok, true} <-
           PermissionRepository.can_do_this_action(%{
             permission: options,
             role: conn.assigns[:role]
           }) do
      conn
    else
      _ ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(401, Jason.encode!(%{message: "unauthorized"}))
        |> halt()
    end
  end
end
