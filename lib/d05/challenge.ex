defmodule D05.Challenge do
  @moduledoc false

  require Logger

  def run(1) do
    lines = Utils.read_input(5, &map_input/1)

    result =
      lines
      |> Stream.reject(&diagonal?/1)
      |> Stream.flat_map(&cover_points/1)
      # Count how often a point is covered
      |> Enum.frequencies()
      # Count the points that are covered multiple times
      |> Enum.count(fn {_, val} -> val > 1 end)

    Logger.info("#{result} points are visited multiple times")
  end

  def run(2) do
    lines = Utils.read_input(5, &map_input/1)

    result =
      lines
      |> Stream.flat_map(&cover_points/1)
      # Count how often a point is covered
      |> Enum.frequencies()
      # Count the points that are covered multiple times
      |> Enum.count(fn {_, val} -> val > 1 end)

    Logger.info("#{result} points are visited multiple times, even by diagonals")
  end

  defp map_input(string) do
    points = String.split(string, " -> ")

    %{
      a: parse_point(Enum.at(points, 0)),
      b: parse_point(Enum.at(points, 1))
    }
  end

  defp parse_point(point_string) do
    values = String.split(point_string, ",") |> Enum.map(&String.to_integer/1)

    %{
      x: Enum.at(values, 0),
      y: Enum.at(values, 1)
    }
  end

  defp diagonal?(%{a: %{x: x1, y: y1}, b: %{x: x2, y: y2}}) when x1 == x2 or y1 == y2, do: false
  defp diagonal?(_), do: true

  defp cover_points(%{a: %{x: x1, y: y1}, b: %{x: x2, y: y2}} = _line) do
    x_diff = x2 - x1
    y_diff = y2 - y1
    x_dir = dir(x_diff)
    y_dir = dir(y_diff)
    length = max(abs(x_diff), abs(y_diff))

    Range.new(0, length)
    |> Enum.map(fn step ->
      %{x: x1 + step * x_dir, y: y1 + step * y_dir}
    end)
  end

  defp dir(n) when n > 0, do: 1
  defp dir(n) when n < 0, do: -1
  defp dir(n) when n == 0, do: 0
end
