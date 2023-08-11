defmodule Rpi4MouseUi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      Rpi4MouseUiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Rpi4MouseUi.PubSub},
      # Start the Endpoint (http/https)
      Rpi4MouseUiWeb.Endpoint
      # Start a worker by calling: Rpi4MouseUi.Worker.start_link(arg)
      # {Rpi4MouseUi.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Rpi4MouseUi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Rpi4MouseUiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
