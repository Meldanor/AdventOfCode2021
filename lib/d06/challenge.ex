defmodule D06.Challenge do
  @moduledoc """
  Solution scheme: Instead of managing an array and counting the occurrence of each one, we will put the lantern
  fish in buckets by their age and just shift the numbers of 8 buckets instead of an exponential amount of list items.

  Each bucket is <Age> -> <Amount of Lantern Fish>.

  We sum up the amount of lantern fish at the end.
  """

  require Logger

  def run(1) do
    start_lantern_fish = Utils.read_input(6, &map_input/1) |> hd

    result = simulate_for(80, start_lantern_fish)

    Logger.info("After 80 days there are #{result} lantern fishes!")
  end

  def run(2) do
    start_lantern_fish = Utils.read_input(6, &map_input/1) |> hd

    result = simulate_for(256, start_lantern_fish)

    Logger.info("After 256 days there are #{result} lantern fishes!")
  end

  defp simulate_for(days, start_lantern_fish) do
    1..days
    |> Enum.reduce(population(start_lantern_fish), &grow_population/2)
    |> Stream.map(fn {_, val} -> val end)
    |> Enum.sum()
  end

  defp map_input(string) do
    string
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  defp population(lantern_fish) do
    Enum.frequencies(lantern_fish)
  end

  defp grow_population(_day, population) do
    map =
      1..8
      |> Enum.map(fn age -> {age - 1, Map.get(population, age, 0)} end)
      |> Map.new()
      # Seven ons gets older and every one that has given birth starts at 6 again
      |> Map.put(6, Map.get(population, 7, 0) + Map.get(population, 0, 0))
      # The new borns itself
      |> Map.put(8, Map.get(population, 0, 0))
  end
end
