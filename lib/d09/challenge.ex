defmodule D09.Challenge do
  @moduledoc """
  Solution sketch:

  The first part is quite simple: Create a 2D array (I use a 1D array with indexing) and scan every points if their
  direct neighbors have lower values (or the scanned point is 9 itself, which cannot be lower than the rest). If so, it
  is a low point and it's height value is added to the list. The list itself is summed by adding 1 to each value.

  The second part reuses the list of part 1 but instead of storing the value of the point the point itself is stored.
  This list of low points is used to create basins. Each point is visited and by using breath-first search the basin
  is explored until there are no valid points (outside the map) or a 9 is visited.
  We now have a list of basin consisting a point lists. We count the points of points in the basin, sort them by their
  size to find the top 3 and build the product of their size for the answer.
  """

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
    height_map = Utils.read_input(9, &map_input/1) |> build_height_map

    result =
      height_map.values
      |> Stream.with_index()
      |> Enum.reduce([], fn {_val, index}, low_points ->
        if low_point?(height_map, index) do
          low_points ++ [to_point(height_map, index)]
        else
          low_points
        end
      end)
      |> Stream.map(&create_basin(height_map, &1))
      |> Stream.map(&length/1)
      |> Enum.sort(:desc)
      |> Enum.take(3)
      |> Enum.product()

    Logger.info("The product of the three biggest basins is #{result}")
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

  defp neighbors({x, y}) do
    [
      {x + 1, y},
      {x, y + 1},
      {x - 1, y},
      {x, y - 1}
    ]
  end

  defp low_point?(%{values: values} = height_map, index) do
    val = Enum.at(values, index)

    # The highest value of the heightmap cannot be a low point, no need to check the neighbors
    if val == 9 do
      false
    else
      height_map
      |> to_point(index)
      |> neighbors()
      |> Stream.map(&at(height_map, &1))
      |> Stream.reject(&is_nil/1)
      |> Enum.all?(fn n -> n > val end)
    end
  end

  defp create_basin(height_map, low_point) do
    neighbors = valid_neighbors(height_map, low_point)

    1..length(height_map.values)
    |> Enum.reduce_while({MapSet.new([low_point]), neighbors}, fn _, {visited_points, queue} ->
      if queue == [] do
        {:halt, MapSet.to_list(visited_points)}
      else
        point = hd(queue)
        queue = tl(queue)

        possible_neighbors =
          height_map
          |> valid_neighbors(point)
          |> Enum.reject(fn neighbor -> MapSet.member?(visited_points, neighbor) end)

        {:cont, {MapSet.put(visited_points, point), Enum.uniq(queue ++ possible_neighbors)}}
      end
    end)
  end

  defp valid_neighbors(height_map, point) do
    point
    |> neighbors()
    |> Stream.map(fn new_neighbor -> {new_neighbor, at(height_map, new_neighbor)} end)
    |> Stream.reject(fn {_point, val} -> val == nil or val == 9 end)
    |> Enum.map(fn {point, _} -> point end)
  end
end
