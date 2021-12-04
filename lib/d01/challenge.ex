defmodule D01.Challenge do
  @moduledoc false

  require Logger

  def run(1) do
    result =
      File.read!("./lib/d01/input")
      |> String.split("\n")
      |> Enum.reject(fn s -> String.length(s) == 0 end)
      |> Enum.map(&String.to_integer/1)
      |> count_increases()

    Logger.info("#{result.increased}x increased")
  end

  def run(2) do
    result =
      File.read!("./lib/d01/input")
      |> String.split("\n")
      |> Enum.reject(fn s -> String.length(s) == 0 end)
      |> Enum.map(&String.to_integer/1)
      |> sum_windows()
      |> count_increases()

    Logger.info("3-Sums #{result.increased}x increased")
  end

  defp sum_windows(values) do
    values
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
    |> Enum.reject(fn i -> i == 0 end)
  end

  defp count_increases(values) do
    values
    |> Enum.reduce(
      %{increased: 0, last: Integer.pow(2, 31) - 1},
      fn e,
         %{
           increased: increased,
           last: last
         } ->
        %{increased: increased + increased_scalar(e, last), last: e}
      end
    )
  end

  defp increased_scalar(a, b) when a > b, do: 1
  defp increased_scalar(_a, _b), do: 0
end
