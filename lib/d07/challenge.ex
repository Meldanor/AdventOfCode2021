defmodule D07.Challenge do
  @moduledoc false

  require Logger

  def run(1) do
    crap_positions =
      Utils.read_input(7) |> hd |> String.split(",") |> Enum.map(&String.to_integer/1)

    minimal_fuel_average =
      average(crap_positions) |> total_distance_from_minimum(crap_positions, :constant)

    Logger.info("The average of all crap positions is #{average(crap_positions)}")

    minimal_fuel_median =
      median(crap_positions) |> total_distance_from_minimum(crap_positions, :constant)

    Logger.info("The median of all crap positions is #{median(crap_positions)}")

    Logger.info(
      "The crabs do need an average of #{minimal_fuel_average} fuel and a median of #{minimal_fuel_median} fuel "
    )
  end

  def run(2) do
    crap_positions =
      Utils.read_input(7) |> hd |> String.split(",") |> Enum.map(&String.to_integer/1)

    average = average(crap_positions)

    median = median(crap_positions)
    result =
    # Possible numbers - it must be around their average or median
    [
      {"Average - 1", average - 1},
      {"Average    ", average},
      {"Average + 1", average + 1},
      {"Median  - 1", median - 1},
      {"Median     ", median},
      {"Median  + 1", median + 1 }
    ]
    # Calculate it for all their positions
    |> Stream.map(fn {name, val} -> {name, val, total_distance_from_minimum(val, crap_positions, :increasing)} end)
    # Find the minimum number
    |> Enum.sort_by(fn {_name, _val, sum} -> sum end)
    |> IO.inspect()
    |> hd()

    Logger.info("The craps need a minimum of #{elem(result, 2)} fuel ")
  end

  defp average(numbers) do
    (Enum.sum(numbers) / length(numbers)) |> Kernel.round()
  end

  defp median(numbers) do
    numbers
    |> Enum.sort()
    |> Enum.at(trunc(length(numbers) / 2))
  end

  defp total_distance_from_minimum(minimum, numbers, :constant) do
    numbers
    |> Stream.map(fn number -> abs(minimum - number) end)
    |> Enum.sum()
  end


  defp total_distance_from_minimum(minimum, numbers, :increasing) do
    numbers
    |> Stream.map(fn number -> sum_of_natural_numbers(abs(minimum - number)) end)
    |> Enum.sum()
  end

  defp sum_of_natural_numbers(n) do
    ((n * (n + 1)) / 2) |> trunc
  end
end
