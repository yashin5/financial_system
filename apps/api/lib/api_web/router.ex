defmodule ApiWeb.Router do
  @moduledoc false

  use ApiWeb, :router

  pipeline :create do
    plug(:accepts, ["json"])
  end

  scope "/api", ApiWeb do
    pipe_through(:create)

    post("/accounts", AccountsController, :create)
    post("/accounts/authenticate", AccountsController, :authenticate)
  end

  pipeline :api_can_create do
    plug(:accepts, ["json"])
    plug(ApiWeb.Auth, [])
    plug(ApiWeb.PermissionCanCreate, [])
  end

  scope "/api", ApiWeb do
    pipe_through(:api_can_create)

    post("/operations/deposit", OperationsController, :deposit)
    post("/operations/withdraw", OperationsController, :withdraw)
    post("/operations/transfer", OperationsController, :transfer)
    post("/operations/split", OperationsController, :split)
  end

  pipeline :api_can_delete do
    plug(:accepts, ["json"])
    plug(ApiWeb.Auth, [])
    plug(ApiWeb.PermissionCanDelete, [])
  end

  scope "/api", ApiWeb do
    pipe_through(:api_can_delete)

    delete("/accounts/:id", AccountsController, :delete)
  end

  pipeline :api_can_view do
    plug(:accepts, ["json"])
    plug(ApiWeb.Auth, [])
    plug(ApiWeb.PermissionCanView, [])
  end

  scope "/api", ApiWeb do
    pipe_through(:api_can_view)

    get("/operations/financial_statement", OperationsController, :financial_statement)
  end

  pipeline :api_can_view_all do
    plug(:accepts, ["json"])
    plug(ApiWeb.Auth, [])
    plug(ApiWeb.PermissionCanViewAll, [])
  end

  scope "/api", ApiWeb do
    pipe_through(:api_can_view_all)

    get("/operations/financial_statement/:email", OperationsController, :financial_statement)
  end
end
