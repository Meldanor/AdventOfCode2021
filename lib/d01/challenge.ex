defmodule D01.Challenge do
  @moduledoc false

  require Logger

  def run do
    Logger.info("Day 1 challenge")

    IO.inspect(Path.absname("."))
    result = File.read!("./lib/d01/input")
    |> String.split("\n")
    |> Enum.reject(fn s -> String.length(s) == 0 end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(%{increased: 0, last: Integer.pow(2, 31) - 1}, fn e, %{increased: increased, last: last} ->
      diff = (e - last) |> sign |> Kernel.max(0)
      %{increased: increased + diff, last: e}
    end)
    Logger.info("#{result.increased}x increased")
  end

  defp sign(integer) when integer >= 0, do: 1
  defp sign(integer) when integer < 0, do: -1
end
