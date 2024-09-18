defmodule GeoJSON.Decode do
  def decode!(data) do
    case decode(data) do
      {:error, reason} -> raise ArgumentError, reason
      {:ok, result} -> result
    end
  end

  def decode(data) do
    case Map.get(data, "type") || Map.get(data, :type) do
      nil ->
        {:error, "Missing 'type' field in data"}

      type ->
        case decode(to_string(type), data) do
          {:error, reason} -> {:error, reason}
          result -> {:ok, result}
        end
    end
  end

  def decode("FeatureCollection", data), do: decode_feature_collection(data)
  def decode("Feature", data), do: decode_feature(data)
  def decode("Point", data), do: decode_point(data)
  def decode("Polygon", data), do: decode_polygon(data)

  def decode(type, _data) do
    {:error, "Unknown type: #{inspect(type)}"}
  end

  defp decode_feature_collection(data) do
    %GeoJSON.FeatureCollection{}
    |> read_features(data)
  end

  defp decode_feature(data) do
    %GeoJSON.Feature{}
    |> read_id(data)
    |> read_properties(data)
    |> read_additional_properties(data)
    |> read_geometry(data)
  end

  defp decode_point(data) do
    %GeoJSON.Point{}
    |> read_coordinates(data)
  end

  defp decode_polygon(data) do
    %GeoJSON.Polygon{}
    |> read_coordinates(data)
  end

  defp read_features(feature, data) do
    case Map.get(data, "features") do
      nil ->
        feature

      features ->
        feature
        |> Map.put(:features, Enum.map(features, &decode!/1))
    end
  end

  def read_id(feature, data) do
    case Map.get(data, "id") do
      nil ->
        feature

      id ->
        feature
        |> Map.put(:id, id)
    end
  end

  def read_bounding_box(feature, data) do
    case Map.get(data, "bbox") do
      nil ->
        feature

      bbox ->
        safe_read_coordinates(feature, bbox, :bbox)
    end
  end

  def read_coordinates(feature, data) do
    case Map.get(data, "coordinates") || Map.get(data, :coordinates) do
      nil ->
        {:error, "No coordinates found in #{inspect(data)}"}

      coordinates ->
        safe_read_coordinates(feature, coordinates, :coordinates)
    end
  end

  def read_additional_properties(feature, data) do
    case feature do
      {:error, arg} ->
        {:error, arg}

      %GeoJSON.Feature{} ->
        feature
        |> Map.merge(
          Map.new(data, fn
            {key, value} when is_binary(key) -> {String.to_atom(key), value}
            {key, value} -> {key, value}
          end)
          |> Map.drop([:id, :properties, :geometry, :type])
        )
    end
  end

  def read_properties(feature, data),
    do: Map.put(feature, :properties, Map.get(data, "properties", %{}))

  def read_geometry(feature, data) do
    case Map.get(data, "geometry") do
      nil ->
        {:error, "No geometry found in #{inspect(data)}"}

      geometry ->
        feature
        |> Map.put(:geometry, decode!(geometry))
    end
  end

  defp safe_read_coordinates(feature, data, target_key) do
    try do
      feature |> Map.put(target_key, read_coordinates(data))
    rescue
      e in ArgumentError ->
        {:error, e.message}
    end
  end

  def read_coordinates(data) when is_list(data) do
    if Enum.all?(data, fn x -> is_number(x) or is_binary(x) end) do
      data
      |> Enum.map(&parse_numeric/1)
      |> List.to_tuple()
    else
      Enum.map(data, &read_coordinates/1)
    end
  end

  def read_coordinates(data) when is_tuple(data) do
    data |> Tuple.to_list() |> read_coordinates()
  end

  def read_coordinates(data) when is_binary(data) do
    case Float.parse(data) do
      {float, ""} ->
        float

      :error ->
        case Integer.parse(data) do
          {integer, ""} -> integer
          :error -> raise ArgumentError, "Invalid numeric string: #{inspect(data)}"
        end
    end
  end

  def read_coordinates(data) when is_number(data), do: data

  defp parse_numeric(x) when is_integer(x), do: x * 1.0

  defp parse_numeric(x) when is_number(x), do: x

  defp parse_numeric(x) when is_binary(x) do
    case Float.parse(x) do
      {float, ""} ->
        float

      _ ->
        case Integer.parse(x) do
          {int, ""} -> int
          _ -> raise ArgumentError, "Invalid numeric string: #{inspect(x)}"
        end
    end
  end
end
