defmodule D05.Challenge do
  @moduledoc false

  require Logger

  def run(1) do
    lines = Utils.read_input(5, &map_input/1)

    result =
      lines
      |> Stream.flat_map(&cover_points/1)
      # Count how often a point is covered
      |> Enum.frequencies()
      # Count the points that are covered multiple times
      |> Enum.count(fn {_, val} -> val > 1 end)

    Logger.info("#{result} points are visited multiple times")
  end

  def run(2) do
    lines = Utils.read_input(5, &map_input/1)
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

  defp cover_points(%{a: %{x: x1, y: y1}, b: %{x: x2, y: y2}} = _line) when x1 == x2 do
    Range.new(y1, y2)
    |> Stream.map(fn y -> %{x: x1, y: y} end)
  end

  defp cover_points(%{a: %{x: x1, y: y1}, b: %{x: x2, y: y2}} = _line) when y1 == y2 do
    Range.new(x1, x2)
    |> Stream.map(fn x -> %{x: x, y: y1} end)
  end

  # Do not cover diagonal lines
  defp cover_points(_) do
    []
  end
end
