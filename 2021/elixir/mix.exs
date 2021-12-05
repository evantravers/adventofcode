defmodule Advent2021.Mixfile do
  use Mix.Project

  def project do
    [
      app: :advent2021,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:angle, "~> 0.3.0"},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:timex, "~> 3.1"},
      {:libgraph, "~> 0.7"},
      {:combination, "~> 0.0.3"}
    ]
  end
end
