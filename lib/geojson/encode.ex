defmodule GeoJSON.Encode do
  alias GeoJSON.{Feature, FeatureCollection, Point, MultiPoint, Polygon, MultiPolygon}

  def encode!(data) do
    case encode(data) do
      {:error, reason} -> raise ArgumentError, reason
      {:ok, result} -> result
    end
  end

  # Add this clause to handle already encoded GeoJSON
  def encode(%{"type" => _} = geojson) do
    {:ok, geojson}
  end

  def encode(obj) do
    {:ok, encode_object(obj)}
  end

  defp encode_object(%Feature{} = feature) do
    %{
      "type" => "Feature",
      "geometry" => encode_object(feature.geometry)
    }
    |> put_id(feature)
    |> put_bbox(feature)
    |> put_properties(feature)
  end

  defp encode_object(%FeatureCollection{} = feature_collection) do
    %{
      "type" => "FeatureCollection",
      "features" => Enum.map(feature_collection.features, &encode_object/1)
    }
    |> put_bbox(feature_collection)
  end

  defp encode_object(%Point{} = point) do
    %{
      "type" => "Point",
      "coordinates" => encode_coordinates(point.coordinates)
    }
  end

  defp encode_object(%MultiPoint{} = multi_point) do
    %{
      "type" => "MultiPoint",
      "coordinates" => Enum.map(multi_point.coordinates, &encode_coordinates/1)
    }
  end

  defp encode_object(%Polygon{} = polygon) do
    %{
      "type" => "Polygon",
      "coordinates" => Enum.map(polygon.coordinates, &encode_coordinates/1)
    }
  end

  defp encode_object(%MultiPolygon{} = multi_polygon) do
    %{
      "type" => "MultiPolygon",
      "coordinates" => Enum.map(multi_polygon.coordinates, &encode_coordinates/1)
    }
  end

  defp encode_coordinates(coordinates) when is_list(coordinates) do
    Enum.map(coordinates, &encode_coordinates/1)
  end

  defp encode_coordinates(coordinates) when is_tuple(coordinates) do
    Tuple.to_list(coordinates)
  end

  defp put_id(data, %{id: id}) when is_nil(id), do: data

  defp put_id(data, %{id: id}) do
    Map.put(data, "id", id)
  end

  defp put_id(data, _), do: data

  defp put_bbox(data, %{bbox: bbox}) when is_nil(bbox), do: data

  defp put_bbox(data, %{bbox: bbox}) do
    Map.put(data, "bbox", bbox)
  end

  defp put_bbox(data, _), do: data

  defp put_properties(data, %{properties: props}) when props == %{}, do: data

  defp put_properties(data, %{properties: properties}) do
    Map.put(data, "properties", properties)
  end

  defp put_properties(data, _), do: data
end
