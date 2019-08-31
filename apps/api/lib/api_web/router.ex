defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :create do
    plug(:accepts, ["json"])
  end

  scope "/api", ApiWeb do
    pipe_through(:create)

    post("/accounts", AccountsController, :create)
    post("/accounts/authenticate", AccountsController, :authenticate)
  end

  pipeline :api do
    plug(:accepts, ["json"])
    plug(ApiWeb.Auth, [])
  end

  scope "/api", ApiWeb do
    pipe_through(:api)

    delete("/accounts/:id", AccountsController, :delete)
    post("/operations/deposit", OperationsController, :deposit)
    post("/operations/withdraw", OperationsController, :withdraw)
    post("/operations/transfer", OperationsController, :transfer)
    post("/operations/split", OperationsController, :split)
    get("/operations/financial_statement/:id", OperationsController, :financial_statement)
  end
end
