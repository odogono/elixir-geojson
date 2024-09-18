defmodule GeoJSONBoundsTest do
  use ExUnit.Case
  doctest GeoJSON.Bounds

  alias GeoJSON.{Bounds, Point, Polygon, LineString, Feature, FeatureCollection}

  describe "calculating bounds" do
    test "calculate bounds for a 2D Point" do
      point = %Point{coordinates: {10, 20}}
      assert Bounds.calculate(point) == {10, 20, 10, 20}
    end

    test "calculate bounds for a 3D Point" do
      point = %Point{coordinates: {10, 20, 30}}
      assert Bounds.calculate(point) == {10, 20, 30, 10, 20, 30}
    end

    test "calculate bounds for a simple 2D Polygon" do
      polygon = %Polygon{
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

      assert Bounds.calculate(polygon) == {0, 0, 10, 10}
    end

    test "calculate bounds for a simple 3D Polygon" do
      polygon = %Polygon{
        coordinates: [
          [
            {0, 0, 0},
            {10, 0, 1},
            {10, 10, 2},
            {0, 10, 1},
            {0, 0, 0}
          ]
        ]
      }

      assert Bounds.calculate(polygon) == {0, 0, 0, 10, 10, 2}
    end

    test "calculate bounds for a 2D LineString" do
      line_string = %LineString{
        coordinates: [
          {0, 0},
          {10, 10},
          {20, 5},
          {30, 15}
        ]
      }

      assert Bounds.calculate(line_string) == {0, 0, 30, 15}
    end

    test "calculate bounds for a 3D LineString" do
      line_string = %LineString{
        coordinates: [
          {0, 0, 0},
          {10, 10, 5},
          {20, 5, 10},
          {30, 15, 2}
        ]
      }

      assert Bounds.calculate(line_string) == {0, 0, 0, 30, 15, 10}
    end

    test "calculate bounds for a Polygon with a hole" do
      polygon = %Polygon{
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

      assert Bounds.calculate(polygon) == {0, 0, 20, 20}
    end

    test "calculate bounds for a complex Polygon" do
      polygon = %Polygon{
        coordinates: [
          [
            {-10, -10},
            {30, -5},
            {40, 40},
            {-5, 30},
            {-10, -10}
          ]
        ]
      }

      assert Bounds.calculate(polygon) == {-10, -10, 40, 40}
    end

    test "calculate bounds for a LineString" do
      line_string = %LineString{
        coordinates: [
          {0, 0},
          {10, 10},
          {20, 5},
          {30, 15}
        ]
      }

      assert Bounds.calculate(line_string) == {0, 0, 30, 15}
    end

    test "calculate bounds for a LineString with negative coordinates" do
      line_string = %LineString{
        coordinates: [
          {-10, -5},
          {0, 0},
          {15, -10},
          {20, 5}
        ]
      }

      assert Bounds.calculate(line_string) == {-10, -10, 20, 5}
    end
  end

  describe "applying bounds" do
    test "apply bounds to a Feature with a Point" do
      feature = %Feature{geometry: %Point{coordinates: {10, 20}}}
      {:ok, result} = Bounds.apply(feature)
      assert result.bbox == {10, 20, 10, 20}
    end

    test "apply bounds to a Feature with a Polygon" do
      feature = %Feature{
        id: "1",
        geometry: %Polygon{
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
      }

      {:ok, result} = Bounds.apply(feature)
      assert result.bbox == {0, 0, 10, 10}
      assert result.id == "1"
    end

    test "apply bounds to a FeatureCollection" do
      feature_collection = %FeatureCollection{
        features: [
          %Feature{geometry: %Point{coordinates: {0, 0}}},
          %Feature{geometry: %Point{coordinates: {10, 10}}},
          %Feature{
            geometry: %Polygon{
              coordinates: [
                [
                  {5, 5},
                  {15, 5},
                  {15, 15},
                  {5, 15},
                  {5, 5}
                ]
              ]
            }
          }
        ]
      }

      {:ok, result} = Bounds.apply(feature_collection)
      assert result.bbox == {0, 0, 15, 15}
    end

    test "apply! bounds to a Feature" do
      feature = %Feature{geometry: %Point{coordinates: {10, 20}}}
      result = Bounds.apply!(feature)
      assert result.bbox == {10, 20, 10, 20}
    end

    test "apply! bounds to a FeatureCollection" do
      feature_collection = %FeatureCollection{
        features: [
          %Feature{geometry: %Point{coordinates: {0, 0}}},
          %Feature{geometry: %Point{coordinates: {10, 10}}}
        ]
      }

      result = Bounds.apply!(feature_collection)
      assert result.bbox == {0, 0, 10, 10}
    end
  end
end
