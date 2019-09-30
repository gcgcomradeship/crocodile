defmodule CrocodileWeb.Router do
  use CrocodileWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CrocodileWeb do
    pipe_through :browser

    resources "/pages", PageController, only: [:index]
    resources "/registrations", Admin.AdminController, only: [:create, :new]

    get "/sign-in", SessionController, :new
    post "/sign-in", SessionController, :create
    delete "/sign-out", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", CrocodileWeb do
  #   pipe_through :api
  # end
end
