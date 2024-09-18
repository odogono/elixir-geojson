defmodule GeoJSON.EncodeTest do
  use ExUnit.Case

  test "encode a Feature" do
    feature = %GeoJSON.Feature{
      geometry: %GeoJSON.Point{coordinates: {100.0, 0.0}},
      properties: %{"name" => "Test Feature"}
    }

    assert %{
             "type" => "Feature",
             "geometry" => %{"type" => "Point", "coordinates" => [100.0, 0.0]},
             "properties" => %{"name" => "Test Feature"}
           } = feature |> GeoJSON.Encode.encode!()
  end
end
