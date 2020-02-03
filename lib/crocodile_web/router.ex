defmodule CrocodileWeb.Router do
  use CrocodileWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    if Mix.env() == :prod do
      plug Crocodile.Plug.BasicAuth, username: "admin", password: "Arbuz123"
    end
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_white do
    plug(Crocodile.Plug.Whitelist)
  end

  pipeline :user_auth do
    plug(Crocodile.Plug.UserAuth)
  end

  pipeline :nav_data_load do
    plug(Crocodile.Plug.NavDataLoad)
  end

  pipeline :admin do
    plug :put_layout, {CrocodileWeb.LayoutView, :admin}
    # plug(:browser)
    plug(Crocodile.Plug.AdminAuth)
  end

  scope "/", CrocodileWeb do
    pipe_through :browser
    pipe_through :user_auth
    pipe_through :nav_data_load
    # Session pages
    get("/sign_in", SessionController, :new)
    get("/sign_up", SessionController, :sign_up, as: :sign_up_session)
    post("/sign_up", SessionController, :sign_up_create, as: :sign_up_session)
    post("/sign_in", SessionController, :create)
    get("/sign_out", SessionController, :delete)
    # Site pages
    get "/", PageController, :index
    # get "/catalog", PageController, :catalog
    get "/delivery", PageController, :delivery
    get "/about", PageController, :about

    # Cart routes
    get "/cart", CartController, :index
    get "/cart/del_item", CartController, :del_item
    get "/cart/add_item", CartController, :add_item
    get "/cart/set_count", CartController, :set_count

    # Modal routes
    get "/modal/item", ModalController, :item

    # Order routes
    resources "/order", OrderController, only: [:new, :create, :show]

    # Test pages
    get "/main", PageController, :main
    get "/catalog", ProductController, :index
    get "/item/:id", ProductController, :show
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

  scope "/api/v1", CrocodileWeb.Api.V1, as: :api do
    pipe_through :api
    pipe_through :api_white
    get "/notify", NotifyController, :notify
    post "/notify", NotifyController, :notify
  end

  # Other scopes may use custom stacks.
  # scope "/api", CrocodileWeb do
  #   pipe_through :api
  # end
end
