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
    nil
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

  defp transpose(rows) do
    rows
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end
