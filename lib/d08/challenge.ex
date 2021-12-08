defmodule D08.Challenge do
  @moduledoc """
  Solution sketch:
  As described in part 1 we can identify 1, 4, 7 and 8 by counting their string length. We now have a map of
  1 => cf
  4 => bcdf
  7 => acf
  8 => abcdefg
  (these are ideal values - they can change but have the same meaning!)

  We can use the values of one and four to find the other numbers by looking at the shared segments. For example, if
  the segments of four are ALL included in the tested number with segment length of 6, we can deduct it is a 9. 0 is missing
  the middle segment, 6 is missing the upper right one that are shared with four.

  The same strategy is applied for finding the other missing values and are descriped in the functions itself.
  """

  require Logger

  def run(1) do
    signals = Utils.read_input(8, &map_input/1)

    result =
      signals
      |> Stream.map(&decode_output/1)
      |> Stream.map(&Integer.to_string/1)
      |> Stream.flat_map(&String.codepoints/1)
      |> Stream.filter(fn char -> char in ["1", "4", "7", "8"] end)
      |> Enum.count()

    Logger.info("The numbers 1, 4, 7, 8 appeared #{result} times")
  end

  def run(2) do
    signals = Utils.read_input(8, &map_input/1)

    result =
      signals
      |> Stream.map(&decode_output/1)
      |> Enum.sum()

    Logger.info("The sum of decoded numbers is #{result}")
  end

  defp map_input(line) do
    parts = String.split(line, " | ") |> Enum.map(&String.split(&1, " "))

    %{
      pattern: hd(parts),
      output: tl(parts) |> hd
    }
  end

  defp decode_output(signal) do
    pattern_by_length = Enum.group_by(signal.pattern, &String.length/1)

    output =
      signal.output
      |> Enum.map(fn digit -> String.codepoints(digit) |> Enum.sort() |> Enum.join() end)

    0..9
    |> Enum.map(fn val -> {val, nil} end)
    |> Map.new()
    |> assign_unique(pattern_by_length)
    |> assign_five_segments(pattern_by_length[5])
    |> assign_six_segments(pattern_by_length[6])
    |> invert_mapping()
    |> decode_output(output)
  end

  defp invert_mapping(map) do
    map
    |> Stream.map(fn {key, val} -> {String.codepoints(val) |> Enum.sort() |> Enum.join(), key} end)
    |> Map.new()
  end

  defp decode_output(decoded_map, output) do
    output
    |> Enum.map(&Map.get(decoded_map, &1))
    |> Enum.join()
    |> String.to_integer()
  end

  defp assign_unique(decoded_map, pattern) do
    decoded_map
    |> Map.put(1, Map.get(pattern, 2) |> hd)
    |> Map.put(4, Map.get(pattern, 4) |> hd)
    |> Map.put(7, Map.get(pattern, 3) |> hd)
    |> Map.put(8, Map.get(pattern, 7) |> hd)
  end

  defp assign_five_segments(decoded_map, pattern) do
    # 3 = 1 is completely inside it
    # 5 = (4 - 1) is completely in it
    # 2 otherwise
    four = decoded_map[4] |> String.codepoints()
    one = decoded_map[1] |> String.codepoints()
    four_minus_one = four -- one

    three = Enum.find(pattern, &digit_in?(&1, one))
    pattern = List.delete(pattern, three)
    five = Enum.find(pattern, &digit_in?(&1, four_minus_one))
    pattern = List.delete(pattern, five)

    decoded_map
    |> Map.put(2, pattern |> hd)
    |> Map.put(3, three)
    |> Map.put(5, five)
  end

  defp assign_six_segments(decoded_map, pattern) do
    # 9 = 4 is completely inside it
    # 0 = is not 9, but has 1 in it
    # 6 otherwise
    four = decoded_map[4] |> String.codepoints()
    one = decoded_map[1] |> String.codepoints()

    nine = Enum.find(pattern, &digit_in?(&1, four))
    pattern = List.delete(pattern, nine)
    zero = Enum.find(pattern, &digit_in?(&1, one))
    pattern = List.delete(pattern, zero)

    decoded_map
    |> Map.put(0, zero)
    |> Map.put(6, pattern |> hd)
    |> Map.put(9, nine)
  end

  defp digit_in?(single_pattern, digit) do
    single_pattern = String.codepoints(single_pattern)

    digit
    |> Enum.all?(fn char -> char in single_pattern end)
  end
end
