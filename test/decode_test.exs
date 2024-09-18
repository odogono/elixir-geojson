defmodule DecodeTest do
  use ExUnit.Case
  alias GeoJSON.Decode

  test "decode! valid FeatureCollection" do
    data = %{
      "type" => "FeatureCollection",
      "features" => [
        %{
          "type" => "Feature",
          "geometry" => %{"type" => "Point", "coordinates" => [100.0, 0.0]},
          "properties" => %{"name" => "Test Point"}
        }
      ]
    }

    result = Decode.decode!(data)
    assert %GeoJSON.FeatureCollection{features: [%GeoJSON.Feature{}]} = result
    assert length(result.features) == 1
    assert hd(result.features).geometry.coordinates == {100.0, 0.0}
    assert hd(result.features).properties == %{"name" => "Test Point"}
  end

  test "decode valid Point" do
    data = %{"type" => "Point", "coordinates" => [100.0, 0.0]}
    assert {:ok, %GeoJSON.Point{coordinates: {100.0, 0.0}}} = Decode.decode(data)
  end

  test "decode valid Polygon" do
    data = %{
      "type" => "Polygon",
      "coordinates" => [
        [[100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0]]
      ]
    }

    assert {:ok, %GeoJSON.Polygon{coordinates: [coords]}} = Decode.decode(data)
    assert length(coords) == 5
    assert hd(coords) == {100.0, 0.0}
  end

  test "decode valid Feature with id and properties" do
    data = %{
      "type" => "Feature",
      "id" => "test1",
      "geometry" => %{"type" => "Point", "coordinates" => [100.0, 0.0]},
      "properties" => %{"name" => "Test Feature"}
    }

    assert {:ok, feature} = Decode.decode(data)
    assert %GeoJSON.Feature{} = feature
    assert feature.id == "test1"
    assert feature.properties == %{"name" => "Test Feature"}
    assert feature.geometry.coordinates == {100.0, 0.0}
  end

  test "decode valid Feature with bbox" do
    data = %{
      "type" => "Feature",
      "bbox" => [100.0, 0.0, 100.0, 0.0],
      "geometry" => %{"type" => "Point", "coordinates" => [100.0, 0.0]},
      "properties" => %{"name" => "Test Feature"}
    }

    assert {:ok, feature} = Decode.decode(data)
    assert %GeoJSON.Feature{} = feature
    assert feature.bbox == [100.0, 0.0, 100.0, 0.0]
  end

  test "decode with missing type" do
    data = %{"coordinates" => [100.0, 0.0]}
    assert {:error, "Missing 'type' field in data"} = Decode.decode(data)
  end

  test "decode with unknown type" do
    data = %{"type" => "Unknown", "coordinates" => [100.0, 0.0]}
    assert {:error, "Unknown type: \"Unknown\""} = Decode.decode(data)
  end

  test "decode! with invalid data raises ArgumentError" do
    data = %{"type" => "Point", "coordinates" => "invalid"}
    assert_raise ArgumentError, fn -> Decode.decode!(data) end
  end
end
