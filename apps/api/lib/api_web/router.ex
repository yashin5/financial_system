defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", ApiWeb do
    pipe_through(:api)

    post("/accounts", AccountsController, :create)
  end
end
