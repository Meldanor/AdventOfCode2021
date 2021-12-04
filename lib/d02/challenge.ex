defmodule D02.Challenge do
  @moduledoc false

  require Logger

  def run(1) do
    result =
      Utils.read_input(2, &map_input/1)
      |> execute_path_day_1

    Logger.info("Final position: #{inspect(result)}. Result: #{Tuple.product(result)}")
  end

  def run(2) do
    result =
      Utils.read_input(2, &map_input/1)
      |> execute_path_day_2

    Logger.info(
      "Final position: #{inspect(result)}. Result: #{elem(result, 0) * elem(result, 1)}"
    )
  end

  defp execute_path_day_1(path), do: Enum.reduce(path, {0, 0}, &execute_day_1/2)

  defp execute_day_1({"forward", x}, {horizontal, depth}), do: {horizontal + x, depth}
  defp execute_day_1({"down", x}, {horizontal, depth}), do: {horizontal, depth + x}
  defp execute_day_1({"up", x}, {horizontal, depth}), do: {horizontal, depth - x}

  defp execute_path_day_2(path), do: Enum.reduce(path, {0, 0, 0}, &execute_day_2/2)

  defp execute_day_2({"forward", x}, {horizontal, depth, aim}),
    do: {horizontal + x, depth + x * aim, aim}

  defp execute_day_2({"down", x}, {horizontal, depth, aim}), do: {horizontal, depth, aim + x}
  defp execute_day_2({"up", x}, {horizontal, depth, aim}), do: {horizontal, depth, aim - x}

  defp map_input(line) do
    split = String.split(line, " ")
    {Enum.at(split, 0), Enum.at(split, 1) |> String.to_integer()}
  end
end
