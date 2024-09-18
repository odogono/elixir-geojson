defmodule GeoJSONTest do
  use ExUnit.Case
  doctest GeoJSON

  # defp data,
  #   do: [
  #     %{
  #       "name" => "Location A",
  #       "category" => "Store",
  #       "street" => "Market",
  #       "lat" => 39.984,
  #       "lng" => -75.343
  #     },
  #     %{
  #       "name" => "Location B",
  #       "category" => "House",
  #       "street" => "Broad",
  #       "lat" => 39.284,
  #       "lng" => -75.833
  #     },
  #     %{
  #       "name" => "Location C",
  #       "category" => "Office",
  #       "street" => "South",
  #       "lat" => 39.123,
  #       "lng" => -74.534
  #     }
  #   ]

  # defp geojsonA,
  #   do: %{
  #     "geometry" => %{
  #       "coordinates" => [[-46.64, -23.577], [-43.2, -22.9], [-43.94, -19.89]],
  #       "type" => "LineString"
  #     },
  #     "properties" => %{
  #       "icon" => "star",
  #       "name" => "Myfavoriteplace",
  #       "rating" => "abillion"
  #     },
  #     "type" => "Feature"
  #   }

  test "decodes" do
    gj = %{
      "type" => "Feature",
      "id" => "123",
      "geometry" => %{
        "type" => "Point",
        "coordinates" => [["10", "20.234"]]
      }
      # "properties" => %{
      #   "title" => "My favorite place"
      # }
    }

    # gj = %{type: "Polygon", coordinates: [[{2, 2}, {20, 2}, {11, 11}, {2, "16", 3}]]}
    # gj = %{"type" => "Feature"}

    GeoJSON.decode(gj) |> IO.inspect()

    GeoJSON.decode!(gj) |> GeoJSON.encode() |> IO.inspect()

    # GeoJSON.decode(geojsonA()) |> IO.inspect()

    # assert GeoJSON.decode(geojsonA()) == geojsonA()
  end

  # test "greets the world" do
  #   point_2d = GeoJSON.Point.new(10.0, 20.0)

  #   p = %GeoJSON.Point{coordinates: {5, 10}}

  #   IO.inspect(point_2d)
  #   IO.inspect(p)

  #   {:ok, result} = GeoJSON.parse(data(), %{Point: ["lat", "lng"]})

  #   assert result == %{
  #            "type" => "FeatureCollection",
  #            "features" => [
  #              %{
  #                "type" => "Feature",
  #                "geometry" => %{
  #                  "type" => "Point",
  #                  "coordinates" => [-75.343, 39.984]
  #                },
  #                "properties" => %{
  #                  "name" => "Location A",
  #                  "category" => "Store",
  #                  "street" => "Market"
  #                }
  #              },
  #              %{
  #                "type" => "Feature",
  #                "geometry" => %{
  #                  "type" => "Point",
  #                  "coordinates" => [-75.833, 39.284]
  #                },
  #                "properties" => %{
  #                  "name" => "Location B",
  #                  "category" => "House",
  #                  "street" => "Broad"
  #                }
  #              },
  #              %{
  #                "type" => "Feature",
  #                "geometry" => %{
  #                  "type" => "Point",
  #                  "coordinates" => [-75.534, 39.123]
  #                },
  #                "properties" => %{
  #                  "name" => "Location C",
  #                  "category" => "Office",
  #                  "street" => "South"
  #                }
  #              }
  #            ]
  #          }
  # end

  test "calculate bounding box of a Polygon" do
    polygon = %GeoJSON.Polygon{
      coordinates: [
        [
          {0, 0},
          {10, 0},
          {10, 10},
          {0, 10},
          {0, 0}
        ]
      ]
    }

    assert GeoJSON.calculate_bounds(polygon) == {0, 0, 10, 10}
  end

  test "calculate bounding box of a complex Polygon" do
    polygon = %GeoJSON.Polygon{
      coordinates: [
        [
          {0, 0},
          {20, 0},
          {20, 20},
          {0, 20},
          {0, 0}
        ],
        [
          {5, 5},
          {15, 5},
          {15, 15},
          {5, 15},
          {5, 5}
        ]
      ]
    }

    assert GeoJSON.calculate_bounds(polygon) == {0, 0, 20, 20}
  end
end
