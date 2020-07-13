defmodule Crocodile.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the PubSub system
      {Phoenix.PubSub, name: Crocodile.PubSub},
      # Start the Ecto repository
      Crocodile.Repo,
      # Start the endpoint when the application starts
      CrocodileWeb.Endpoint,
      # Starts a worker by calling: Crocodile.Worker.start_link(arg)
      # {Crocodile.Worker, arg},
      Crocodile.Scheduler
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Crocodile.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CrocodileWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
