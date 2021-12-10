defmodule D10.Challenge do
  @moduledoc false

  require Logger

  def run(1) do
    lines = Utils.read_input(10, &String.codepoints/1)

    result =
      lines
      |> Enum.map(&reduce_line/1)
      |> Enum.reject(&is_list/1)
      |> Enum.map(&point/1)
      |> Enum.sum()

    Logger.info("The total syntax error score is #{result}")
  end

  def run(2) do
    lines = Utils.read_input(10, &String.codepoints/1)
  end

  defp reduce_line(line) do
    line
    |> Enum.reduce_while([], fn symbol, stack ->
      {last_symbol, stack} = pop(stack)

      if is_nil(last_symbol) do
        {:cont, [symbol] ++ stack}
      else
        if close?(symbol) do
          if closing?(symbol, last_symbol) do
            {:cont, stack}
          else
            {:halt, symbol}
          end
        else
          {:cont, [symbol, last_symbol] ++ stack}
        end
      end
    end)
  end

  defp pop([]), do: {nil, []}
  defp pop(stack), do: {hd(stack), tl(stack)}

  defp open?(char) do
    char in ~w(( { [ <)
  end

  defp close?(char) do
    char in ~w(\) } ] >)
  end

  @brackets %{
    "(" => ")",
    "{" => "}",
    "[" => "]",
    "<" => ">"
  }

  defp opening?(left, right), do: Map.get(@brackets, left) == right
  defp closing?(right, left), do: Map.get(@brackets, left) == right

  defp point(")"), do: 3
  defp point("]"), do: 57
  defp point("}"), do: 1197
  defp point(">"), do: 25137
end
