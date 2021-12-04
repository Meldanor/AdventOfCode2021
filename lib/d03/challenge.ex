defmodule D03.Challenge do
  @moduledoc false

  require Logger

  def run(1) do
    columns =
      Utils.read_input(3, &String.codepoints/1)
      |> transpose

    column_length = length(Enum.at(columns, 0))

    result =
      columns
      |> Enum.map(fn column -> find_gamma_and_epsilon_bit(column, column_length / 2) end)
      |> Enum.zip_with(&Enum.join/1)
      |> Enum.map(&String.to_integer(&1, 2))

    Logger.info(
      "Gamma is #{Enum.at(result, 0)}, epsilon is #{Enum.at(result, 1)}. Result is #{Enum.product(result)}"
    )
  end

  def run(2) do
    rows = Utils.read_input(3, &String.codepoints/1)
    oxygen_bit_amount_func = &Enum.max/1

    oxygen_bit_equal_func = fn counted_bits, size ->
      if Enum.at(counted_bits, 1) == size, do: "1", else: "0"
    end

    co2_bit_amount_func = &Enum.min/1

    co2_bit_equal_func = fn counted_bits, size ->
      if Enum.at(counted_bits, 0) == size, do: "0", else: "1"
    end

    oxygen = find_life_support(rows, 0, oxygen_bit_amount_func, oxygen_bit_equal_func)
    co2 = find_life_support(rows, 0, co2_bit_amount_func, co2_bit_equal_func)

    Logger.info("Oxygen is #{oxygen}, CO2 is #{co2}. Result is #{oxygen * co2}")
  end

  defp find_gamma_and_epsilon_bit(bit_column, column_length) do
    # Check if Zeroes or the most common bit
    zeroes = Enum.count(bit_column, fn x -> x == "0" end)

    # Return 0 for gamma, 1 for epsilon if there are more zeroes than ones
    if zeroes > column_length do
      [0, 1]
    else
      # Otherwise
      [1, 0]
    end
  end

  # Final step in recursion
  defp find_life_support(rows, _, _, _) when length(rows) == 1 do
    rows
    |> Enum.join()
    |> String.to_integer(2)
  end

  defp find_life_support(rows, column_index, bit_amount_func, bit_equal_func) do
    columns = transpose(rows)
    # Count bits in the current column
    counted_bits = count_bits(Enum.at(columns, column_index), length(rows))
    # Find the most / least common bit
    size = bit_amount_func.(counted_bits)
    # For what bit are we looking? 1 or 0?
    bit = bit_equal_func.(counted_bits, size)

    rows
    |> Enum.filter(fn row -> Enum.at(row, column_index) == bit end)
    |> Enum.take(size)
    |> find_life_support(column_index + 1, bit_amount_func, bit_equal_func)
  end

  defp count_bits(bit_column, rows_length) do
    zeroes = Enum.count(bit_column, fn x -> x == "0" end)
    [zeroes, rows_length - zeroes]
  end

  defp transpose(rows) do
    rows
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end
