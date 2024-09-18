defmodule GeoJSON do
  @moduledoc """
  Documentation for `GeoJSON`.
  """

  alias GeoJSON.{Decode, Encode, Generate, Bounds}

  @doc """
  Hello world.

  ## Examples

      iex> GeoJSON.hello()
      :world

  """
  def hello do
    :world
  end

  defdelegate decode(data), to: Decode
  defdelegate decode!(data), to: Decode
  defdelegate encode(data), to: Encode
  defdelegate encode!(data), to: Encode
  defdelegate generate_random(type, min \\ -180, max \\ 180, seed \\ nil), to: Generate
  defdelegate calculate_bounds(polygon), to: Bounds, as: :calculate
end
