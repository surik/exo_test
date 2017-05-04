defmodule ExoTest.Mixfile do
  use Mix.Project

  def project do
    [app: :exo_test,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:elixometer, "~> 1.2"},

      {:metricman,         github: "xerions/metricman"},

      {:lager,             "~> 3.2.2", override: true},
      {:exometer_influxdb, github: "travelping/exometer_influxdb", branch: "master", override: true},
      {:exometer_core,     github: "Feuerlabs/exometer_core", override: true},
      {:edown,             github: "uwiger/edown", override: true},
      {:meck,              github: "eproxus/meck", tag: "0.8.2", override: true},
      {:setup,             github: "uwiger/setup", tag: "1.6", override: true},
    ]
  end
end
