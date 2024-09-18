defmodule GeoJSON.Point do
  @moduledoc """
  Documentation for `GeoJSON.Point`.
  """

  # @enforce_keys [:coordinates]
  defstruct coordinates: nil

  @type t :: %__MODULE__{
          coordinates: {float(), float(), float() | nil}
        }

  @doc """
  Creates a new Point struct with the given coordinates.
  """
  @spec new(float(), float(), float() | nil) :: t()
  def new(lon, lat, alt) do
    %__MODULE__{coordinates: {lon, lat, alt}}
  end

  def new(lon, lat) do
    %__MODULE__{coordinates: {lon, lat}}
  end

  def new() do
    %__MODULE__{coordinates: {0, 0}}
  end
end
