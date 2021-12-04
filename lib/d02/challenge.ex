defmodule D02.Challenge do
  @moduledoc false

  require Logger

  def run(1) do
    result =
      Utils.read_input(2, &map_input/1)
      |> execute_path

    Logger.info("Final position: #{inspect(result)}. Result: #{Tuple.product(result)}")
  end

  def run(2) do
    result =
      Utils.read_input(2, &map_input/1)
      |> execute_path

    Logger.info("Final position: #{inspect(result)} increased")
  end

  defp execute_path(path) do
    path
    |> Enum.reduce({0, 0}, &execute/2)
  end

  defp execute({"forward", x}, {horizontal, depth}), do: {horizontal + x, depth}

  defp execute({"down", x}, {horizontal, depth}), do: {horizontal, depth + x}

  defp execute({"up", x}, {horizontal, depth}), do: {horizontal, depth - x}

  defp map_input(line) do
    split = String.split(line, " ")
    {Enum.at(split, 0), Enum.at(split, 1) |> String.to_integer()}
  end
end
