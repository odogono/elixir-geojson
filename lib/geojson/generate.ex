defmodule GeoJSON.Generate do
  alias GeoJSON.{Feature, FeatureCollection, Point, Polygon, LineString}

  def generate_random(type, min \\ -180, max \\ 180, seed \\ nil)

  def generate_random(%Point{}, min, max, seed) do
    with_seed(seed, fn ->
      %Point{
        coordinates: {
          random_coordinate(min, max),
          random_coordinate(min, max)
        }
      }
    end)
  end

  def generate_random(%Polygon{}, min, max, seed) do
    with_seed(seed, fn ->
      # Random number of points between 3 and 10
      num_points = Enum.random(3..10)
      coordinates = generate_random_coordinates(num_points + 1, min, max)
      first_point = List.first(coordinates)
      closed_coordinates = coordinates ++ [first_point]

      %Polygon{
        coordinates: [closed_coordinates]
      }
    end)
  end

  def generate_random(%LineString{}, min, max, seed) do
    with_seed(seed, fn ->
      # Random number of points between 2 and 10
      num_points = Enum.random(2..10)
      coordinates = generate_random_coordinates(num_points, min, max)

      %LineString{
        coordinates: coordinates
      }
    end)
  end

  defp generate_random_coordinates(num_points, min, max) do
    Enum.map(1..num_points, fn _ ->
      {random_coordinate(min, max), random_coordinate(min, max)}
    end)
  end

  defp random_coordinate(min, max) do
    :rand.uniform() * (max - min) + min
  end

  defp with_seed(nil, fun), do: fun.()

  defp with_seed(seed, fun) do
    :rand.seed(:exsss, {seed, seed, seed})
    result = fun.()
    :rand.seed(:exsss, :os.timestamp())
    result
  end
end
