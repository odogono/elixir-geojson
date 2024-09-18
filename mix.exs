defmodule GeoJSON.MixProject do
  use Mix.Project

  def project do
    [
      app: :odgn_geojson,
      name: "ODGN GeoJSON",
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
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
      {:odgn_json_pointer, "~> 3.1"},
      {:credo, "~> 1.7.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4.3", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.34.2", only: :dev, runtime: false},
      {:jason, "~> 1.4"},
      {:geo, "~> 3.6", only: [:dev, :test]},
      {:topo, "~> 1.0", only: [:dev, :test]}
    ]
  end
end
