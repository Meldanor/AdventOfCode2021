defmodule D08.Challenge do
  @moduledoc false

  require Logger

  def run(1) do
    signals = Utils.read_input(8, &map_input/1)

    result = signals
    |> Stream.flat_map(&decode_output(&1, :simple))
    |> Stream.reject(&is_nil/1)
    |> Enum.count

    Logger.info("The numbers 1, 4, 7, 8 appeared #{result} times")
  end

  def run(2) do
    _signals = Utils.read_input(8, &map_input/1)
  end

  defp map_input(line) do
    parts = String.split(line, " | ") |> Enum.map(&String.split(&1, " "))
    %{
      pattern: hd(parts),
      output: tl(parts) |> hd
    }
  end

  defp decode_output(signal, :simple) do
    signal
    |> Map.get(:output)
    |> Stream.map(&String.length/1)
    |> Enum.map(&deduct_digit(&1, :simple))
  end

  defp deduct_digit(2, :simple), do: 1
  defp deduct_digit(4, :simple), do: 4
  defp deduct_digit(3, :simple), do: 7
  defp deduct_digit(7, :simple), do: 8
  defp deduct_digit(_signal_value, :simple), do: nil
end
