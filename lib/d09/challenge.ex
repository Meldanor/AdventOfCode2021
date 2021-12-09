defmodule D09.Challenge do
  @moduledoc false

  require Logger

  def run(1) do
    height_map = Utils.read_input(9, &map_input/1) |> build_height_map

    result =
      height_map.values
      |> Stream.with_index()
      |> Enum.reduce([], fn {val, index}, low_points ->
        if low_point?(height_map, index) do
          low_points ++ [val]
        else
          low_points
        end
      end)
      |> Enum.reduce(0, fn low_point, sum ->
        sum + low_point + 1
      end)

    Logger.info("The sum of risk levels is #{result}")
  end

  def run(2) do
    nil
  end

  defp map_input(line), do: String.codepoints(line) |> Enum.map(&String.to_integer/1)

  defp build_height_map(numbers) do
    %{
      width: length(hd(numbers)),
      height: length(numbers),
      values: Enum.concat(numbers)
    }
  end

  defp at(%{width: width, height: height}, {x, y})
       when x < 0 or x >= width or y < 0 or y >= height,
       do: nil

  defp at(%{width: width, values: values}, {x, y}) do
    Enum.at(values, x + y * width)
  end

  defp to_point(%{width: width}, index) do
    x = Kernel.rem(index, width)
    y = (index / width) |> trunc()
    {x, y}
  end

  defp neighbors(height_map, {x, y}) do
    [
      at(height_map, {x + 1, y}),
      at(height_map, {x, y + 1}),
      at(height_map, {x - 1, y}),
      at(height_map, {x, y - 1})
    ]
    |> Enum.reject(&is_nil/1)
  end

  def low_point?(%{values: values} = height_map, index) do
    val = Enum.at(values, index)
    point = to_point(height_map, index)
    neighbors = neighbors(height_map, point)
    Enum.all?(neighbors, fn n -> n > val end)
  end
end
