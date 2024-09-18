defmodule GeoJSON.Bounds do
  alias GeoJSON.{Point, Polygon, LineString, Feature, FeatureCollection}

  def apply!(%Feature{} = feature) do
    {:ok, feature} = apply(feature)
    feature
  end

  def apply!(%FeatureCollection{} = feature_collection) do
    {:ok, feature_collection} = apply(feature_collection)
    feature_collection
  end

  def apply(%Feature{geometry: geometry} = feature) do
    bbox = calculate(geometry)
    {:ok, struct(feature, bbox: bbox)}
  end

  def apply(%FeatureCollection{} = feature_collection) do
    bbox =
      calculate(feature_collection)

    {:ok, struct(feature_collection, bbox: bbox)}
  end

  def calculate(%Point{coordinates: {x, y, z}}) do
    {x, y, z, x, y, z}
  end

  def calculate(%Point{coordinates: {x, y}}) do
    {x, y, x, y}
  end

  def calculate(%LineString{coordinates: coordinates}) do
    calculate_from_coordinates(coordinates)
  end

  def calculate(%Polygon{coordinates: coordinates}) do
    Enum.reduce(coordinates, nil, fn coords, acc ->
      bbox = calculate_from_coordinates(coords)
      merge_bounding_boxes(acc, bbox)
    end)
  end

  def calculate(%Feature{geometry: geometry}) do
    calculate(geometry)
  end

  def calculate(%FeatureCollection{features: features}) do
    Enum.reduce(features, nil, fn feature, acc ->
      merge_bounding_boxes(acc, apply!(feature).bbox)
    end)
  end

  defp calculate_from_coordinates(coordinates) do
    Enum.reduce(coordinates, nil, fn coords, acc ->
      case {coords, acc} do
        {{x, y, z}, nil} ->
          {x, y, z, x, y, z}

        {{x, y}, nil} ->
          {x, y, x, y}

        {{x, y, z}, {min_x, min_y, min_z, max_x, max_y, max_z}} ->
          {
            min(x, min_x),
            min(y, min_y),
            min(z, min_z),
            max(x, max_x),
            max(y, max_y),
            max(z, max_z)
          }

        {{x, y}, {min_x, min_y, max_x, max_y}} ->
          {
            min(x, min_x),
            min(y, min_y),
            max(x, max_x),
            max(y, max_y)
          }
      end
    end)
  end

  defp merge_bounding_boxes(nil, bbox), do: bbox
  defp merge_bounding_boxes(bbox, nil), do: bbox

  defp merge_bounding_boxes(
         {min_x1, min_y1, min_z1, max_x1, max_y1, max_z1},
         {min_x2, min_y2, min_z2, max_x2, max_y2, max_z2}
       ) do
    {
      min(min_x1, min_x2),
      min(min_y1, min_y2),
      min(min_z1, min_z2),
      max(max_x1, max_x2),
      max(max_y1, max_y2),
      max(max_z1, max_z2)
    }
  end

  defp merge_bounding_boxes({min_x1, min_y1, max_x1, max_y1}, {min_x2, min_y2, max_x2, max_y2}) do
    {
      min(min_x1, min_x2),
      min(min_y1, min_y2),
      max(max_x1, max_x2),
      max(max_y1, max_y2)
    }
  end
end
