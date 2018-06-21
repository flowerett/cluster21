defmodule ClusterTest.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    topologies = [
      dns_poll_example: [
        strategy: Cluster.Strategy.DNSPoll,
        config: [
          polling_interval: 5_000,
          query: System.get_env("CONNECT_TO_NODENAME"),
          node_basename: "service"
        ]
      ]
    ]

    # Define workers and child supervisors to be supervised
    children = [
      {Cluster.Supervisor, [topologies, [name: ClusterTest.ClusterSupervisor]]},
      # Start the endpoint when the application starts
      supervisor(ClusterTestWeb.Endpoint, []),
      # Start your own worker by calling: ClusterTest.Worker.start_link(arg1, arg2, arg3)
      # worker(ClusterTest.Worker, [arg1, arg2, arg3]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ClusterTest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ClusterTestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
