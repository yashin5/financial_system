defmodule ApiWeb.Router do
  @moduledoc false

  use ApiWeb, :router

  pipeline :auth do
    plug(:accepts, ["json"])
    plug(ApiWeb.Auth, [])
  end

  pipeline :create do
    plug(:accepts, ["json"])
  end

  pipeline :api_can_view_all do
    plug(ApiWeb.Permissions, :can_view_all)
  end

  pipeline :api_can_view do
    plug(ApiWeb.Permissions, :can_view)
  end

  pipeline :api_can_delete do
    plug(ApiWeb.Permissions, :can_delete)
  end

  pipeline :api_can_create do
    plug(ApiWeb.Permissions, :can_create)
  end

  scope "/api", ApiWeb do
    pipe_through(:create)

    post("/accounts", AccountsController, :create)
    post("/accounts/authenticate", AccountsController, :authenticate)
  end

  scope "/api", ApiWeb do
    pipe_through(:auth)
    pipe_through(:api_can_create)

    post("/operations/deposit", OperationsController, :deposit)
    post("/operations/withdraw", OperationsController, :withdraw)
    post("/operations/transfer", OperationsController, :transfer)
    post("/operations/split", OperationsController, :split)
  end

  scope "/api", ApiWeb do
    pipe_through(:auth)
    pipe_through(:api_can_delete)

    delete("/accounts/:id", AccountsController, :delete)
  end

  scope "/api", ApiWeb do
    pipe_through(:auth)
    pipe_through(:api_can_view)

    get("/operations/financial_statement", OperationsController, :financial_statement)
  end

  scope "/api", ApiWeb do
    pipe_through(:auth)
    pipe_through(:api_can_view_all)

    get("/operations/financial_statement/:email", OperationsController, :financial_statement)
  end
end
