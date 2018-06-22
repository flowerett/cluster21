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

  # for different topologies no need in child_spec
  # {Cluster.Supervisor, [Application.get_env(:libcluster, :topology)]}
  defp get_children("master") do
    [
      Supervisor.child_spec({Cluster.Supervisor, [Application.get_env(:libcluster, :cluster1)]}, id: :cluster1),
      Supervisor.child_spec({Cluster.Supervisor, [Application.get_env(:libcluster, :cluster2)]}, id: :cluster2),
      Supervisor.child_spec({ClusterTestWeb.Endpoint, []}, type: :supervisor)
    ]
  end
end
