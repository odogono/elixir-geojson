defmodule GeoJSON.Feature do
  @moduledoc """
  Documentation for `GeoJSON.Feature`.
  """

  alias GeoJSON.{Point, Polygon, LineString}

  defstruct bbox: nil, geometry: nil, properties: nil, id: nil

  @type geometry :: Point.t() | Polygon.t() | LineString.t()

  @type t :: %__MODULE__{
          bbox: list(number()) | nil,
          geometry: geometry(),
          properties: map(),
          id: String.t() | nil
        }

  def new(geometry, properties \\ %{}, id \\ nil) do
    %__MODULE__{bbox: nil, geometry: geometry, properties: properties, id: id}
  end
end
