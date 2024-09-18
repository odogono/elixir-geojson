defmodule GeoJSON.CyclesTest do
  use ExUnit.Case
  #   doctest GeoJSON.Cycles

  defmodule Graph do
    defstruct [:x, :y, :adj]

    def new(x, y) do
      %__MODULE__{x: x, y: y, adj: []}
    end

    def add_edges(vertices, edges) do
      Enum.reduce(edges, vertices, fn [i1, i2], acc ->
        v1 = Enum.at(acc, i1)
        v2 = Enum.at(acc, i2)

        acc
        |> List.update_at(i1, fn vertex -> %{vertex | adj: [v2 | vertex.adj]} end)
        |> List.update_at(i2, fn vertex -> %{vertex | adj: [v1 | vertex.adj]} end)
      end)
    end
  end

  test "a triangle" do
    # Create vertices
    vertices = [
      Graph.new(0, 0),
      Graph.new(5, 5),
      Graph.new(5, 0)
    ]

    # Define edges
    edges = [
      [0, 1],
      [1, 2],
      [2, 0]
    ]

    # Add edges to the graph
    graph = Graph.add_edges(vertices, edges)

    # Print the result to verify
    IO.inspect(graph, label: "Resulting graph")
  end
end
