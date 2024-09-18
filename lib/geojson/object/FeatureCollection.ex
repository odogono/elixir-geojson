defmodule GeoJSON.FeatureCollection do
  @moduledoc """
  Documentation for `GeoJSON.Feature`.
  """

  defstruct bbox: nil, features: nil, properties: nil

  @type t :: %__MODULE__{
          bbox: list(number()),
          features: [GeoJSON.Feature.t()],
          properties: map()
        }

  def new(features) do
    %__MODULE__{features: features}
  end

  def new() do
    %__MODULE__{features: []}
  end
end
