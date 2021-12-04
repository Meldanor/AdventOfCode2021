defmodule Utils do
  @moduledoc false

  def read_input(day) do
    day
    |> Integer.to_string()
    |> String.pad_leading(2, "0")
    |> (&"./lib/d#{&1}/input").()
    |> File.read!()
    |> String.split("\n")
    |> Enum.reject(fn s -> String.length(s) == 0 end)
  end

  def read_input(day, map_func) do
    day
    |> read_input()
    |> Enum.map(map_func)
  end
end
