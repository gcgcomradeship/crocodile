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

  pipeline :admin do
    plug :put_layout, {CrocodileWeb.LayoutView, :admin}
    # plug(:browser)
    plug(Crocodile.Plug.AdminAuth)
  end

  scope "/", CrocodileWeb do
    pipe_through :browser

    # Site pages
    get "/", PageController, :index
    # get "/catalog", PageController, :catalog
    get "/delivery", PageController, :delivery
    get "/about", PageController, :about

    # Test pages
    get "/main", PageController, :main
    get "/catalog", ProductController, :index
    get "/item", ProductController, :show
    get "/example", PageController, :example
  end

  scope "/admin", CrocodileWeb.Admin, as: :admin do
    pipe_through :browser
    # Session
    get "/sign_in", SessionController, :new
    post "/sign_in", SessionController, :create
    get "/sign_out", SessionController, :delete

    pipe_through([:admin])

    get "/", PageController, :index
    get "/sync", SyncController, :index
    resources "/admin", AdminController, except: [:show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", CrocodileWeb do
  #   pipe_through :api
  # end
end
