# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :cluster_test, ClusterTestWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "sEXnSTASW7Mc+UbQGO9rtu5PPEMRkJisQCQ0sVWJThyr3PFFvvXsMxlgj/Tb03JE",
  render_errors: [view: ClusterTestWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ClusterTest.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :libcluster,
  cluster1: [
    dns_poll_cluster1: [
      strategy: Cluster.Strategy.DNSPoll,
      config: [
        polling_interval: 5_000,
        query: System.get_env("CONNECT_TO_NODE1"),
        node_basename: "service",
        debug: true
      ]
    ]
  ],
  cluster2: [
    dns_poll_cluster1: [
      strategy: Cluster.Strategy.DNSPoll,
      config: [
        polling_interval: 5_000,
        query: System.get_env("CONNECT_TO_NODE2"),
        node_basename: "service",
        debug: true
      ]
    ]
  ]
