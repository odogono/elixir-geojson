defmodule GeoJSON.SVG do
  alias GeoJSON.{Feature, FeatureCollection, Point, Polygon, LineString, Bounds}

  @default_options %{:width => 600, :height => 400, :stroke => "black", :fill => "none"}

  def to_svg(object, options \\ @default_options)

  def to_svg(%FeatureCollection{} = feature_collection, options) do
    bbox = Bounds.calculate(feature_collection)

    paths =
      Enum.map(feature_collection.features, fn feature ->
        # coordinates = feature.geometry.coordinates
        coordinates_to_path(feature, bbox, options)
        # ~s(<path d="#{path}" stroke="#{options.stroke}" fill="#{options.fill}" />)
      end)

    paths_to_svg(paths, options)
  end

  def to_svg(%Feature{} = feature, options) do
    bounds = Bounds.calculate(feature)
    paths = coordinates_to_path(feature, bounds, options)
    paths_to_svg(paths, options)
  end

  defp paths_to_svg(paths, options) do
    content = Enum.join(paths, "\n")

    """
    <svg xmlns="http://www.w3.org/2000/svg" width="#{options.width}" height="#{options.height}">
      #{content}
    </svg>
    """
  end

  defp coordinates_to_path(%Feature{geometry: geometry}, bbox, options) do
    coordinates_to_path(geometry, bbox, options)
  end

  defp coordinates_to_path(%Point{coordinates: coordinates}, bbox, options) do
    coordinates_to_path(coordinates, bbox, options)
  end

  defp coordinates_to_path(%LineString{coordinates: coordinates}, bbox, options) do
    coordinates_to_path(coordinates, bbox, options)
  end

  defp coordinates_to_path(%Polygon{coordinates: coordinates}, bbox, options) do
    width = options.width
    height = options.height

    path =
      Enum.map(coordinates, fn coordinates ->
        coordinates_to_path(coordinates, bbox, width, height)
      end)
      |> Enum.join(" Z ")

    ~s(<path d="#{path}" stroke="#{options.stroke}" fill="#{options.fill}" />)
  end

  defp coordinates_to_path(coordinates, {min_x, min_y, max_x, max_y}, width, height) do
    scale_x = width / (max_x - min_x)
    scale_y = height / (max_y - min_y)
    translate_x = -min_x
    translate_y = -min_y

    coordinates
    |> Enum.map(&translate_and_scale(&1, translate_x, translate_y, scale_x, scale_y))
    |> Enum.reduce("", fn
      {x, y}, "" ->
        "M#{format_coordinate({x, y})}"

      {x, y}, acc ->
        "#{acc} L#{format_coordinate({x, y})}"
    end)
  end

  defp translate_and_scale(point, translate_x, translate_y, scale_x, scale_y) do
    {x, y} = point
    {(x + translate_x) * scale_x, (y + translate_y) * scale_y}
  end

  defp format_coordinate({x, y}) do
    "#{format_coordinate(x)},#{format_coordinate(y)}"
  end

  defp format_coordinate(value) do
    :erlang.float_to_binary(value, [:compact, decimals: 6])
  end
end
