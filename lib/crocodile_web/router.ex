defmodule CrocodileWeb.Router do
  use CrocodileWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    # plug :put_secure_browser_headers

    # if Mix.env() == :prod do
    #   plug Crocodile.Plug.BasicAuth, username: "admin", password: "Arbuz123"
    # end
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_white do
    plug(Crocodile.Plug.Kassa)
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
    get "/page/:name", PageController, :show

    # Cart routes
    get "/cart", CartController, :index
    get "/cart/del_item", CartController, :del_item
    get "/cart/add_item", CartController, :add_item
    get "/cart/set_count", CartController, :set_count

    # Modal routes
    get "/modal/item", ModalController, :item

    # Order routes
    resources "/order", OrderController, only: [:new, :create, :show]
    # Blog routes
    resources "/blog", BlogController, only: [:index, :show] do
      get "/like", BlogController, :like
    end

    # Test pages
    get "/main", PageController, :main
    get "/catalog", ItemController, :index
    get "/item/:id", ItemController, :show
    get "/example", PageController, :example
    get "/maturity/approve", ModalController, :maturity_approve
  end

  scope "/admin", CrocodileWeb.Admin, as: :admin do
    pipe_through :browser
    # Session
    get "/sign_in", SessionController, :new
    post "/sign_in", SessionController, :create
    get "/sign_out", SessionController, :delete

    pipe_through([:admin])

    get "/", PageController, :dashboard
    get "/sync", SyncController, :index
    get "/sync/update", SyncController, :sync
    post "/sync/update", SyncController, :sync

    resources "/admin", AdminController, except: [:show]
    resources "/blog", BlogController
    resources "/instagram", InstagramController
    resources "/partner", PartnerController
    resources "/setting", SettingController, except: [:show, :new, :edit]
    resources "/banner", BannerController, only: [:index, :edit, :update, :create]
    resources "/page", PageController, only: [:index, :edit, :update, :create]

    resources "/approve", ApproveController, only: [:index] do
      get "/approve", ApproveController, :approve
      get "/hide", ApproveController, :hide
    end

    get "/approve/refresh", ApproveController, :refresh

    resources "/order", OrderController do
      get "/archive", OrderController, :archive
      get "/send_remote", OrderController, :send_remote
    end

    resources "/item_order", ItemOrderController, only: [:update, :create, :delete]
  end

  scope "/api/v1", CrocodileWeb.Api.V1, as: :api do
    pipe_through :api
    pipe_through :api_white
    post "/webhook/:token", TelegramController, :webhook
    get "/notify", NotifyController, :notify
    post "/notify", NotifyController, :notify
  end

  # Other scopes may use custom stacks.
  # scope "/api", CrocodileWeb do
  #   pipe_through :api
  # end
end
