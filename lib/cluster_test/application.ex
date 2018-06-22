defmodule ClusterTest.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    # Define workers and child supervisors to be supervised
    children = System.get_env("CLUSTER_ROLE") |> get_children()

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

  defp get_children("slave") do
    [Supervisor.child_spec({ClusterTestWeb.Endpoint, []}, type: :supervisor)]
  end

  defp get_children("master") do
    topologies = [
      [
        dns_poll: [
          strategy: Cluster.Strategy.DNSPoll,
          config: [
            polling_interval: 5_000,
            query: System.get_env("CONNECT_TO_NODE1"),
            node_basename: "service",
            debug: true
          ]
        ]
      ],
      [
        dns_poll: [
          strategy: Cluster.Strategy.DNSPoll,
          config: [
            polling_interval: 5_000,
            query: System.get_env("CONNECT_TO_NODE2"),
            node_basename: "service",
            debug: true
          ]
        ]
      ]
    ]

    topologies
    |> Stream.with_index(1)
    |> Enum.map(fn {topology, ind} ->
      Supervisor.child_spec({Cluster.Supervisor, [topology]}, id: {Cluster.Supervisor, ind})
    end)
    |> :erlang.++(get_children("slave"))
  end
end
