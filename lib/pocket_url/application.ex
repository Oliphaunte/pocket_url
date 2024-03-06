defmodule PocketUrl.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PocketUrlWeb.Telemetry,
      PocketUrl.Repo,
      {DNSCluster, query: Application.get_env(:pocket_url, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PocketUrl.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PocketUrl.Finch},
      # Start a worker by calling: PocketUrl.Worker.start_link(arg)
      # {PocketUrl.Worker, arg},
      # Start to serve requests, typically the last entry
      PocketUrlWeb.Endpoint,
      PocketUrl.Application.UrlsGenServer
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PocketUrl.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PocketUrlWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
