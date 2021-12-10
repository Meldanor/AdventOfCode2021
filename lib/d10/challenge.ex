defmodule D10.Challenge do
  @moduledoc false

  require Logger

  @brackets %{
    "(" => ")",
    "{" => "}",
    "[" => "]",
    "<" => ">"
  }

  def run(1) do
    lines = Utils.read_input(10, &String.codepoints/1)

    result =
      lines
      |> Enum.map(&reduce_line/1)
      |> Enum.reject(&is_list/1)
      |> Enum.map(&point(&1, :corrupt))
      |> Enum.sum()

    Logger.info("The total syntax error score is #{result}")
  end

  def run(2) do
    lines = Utils.read_input(10, &String.codepoints/1)

    result =
      lines
      |> Stream.map(&reduce_line/1)
      |> Stream.filter(&is_list/1)
      |> Stream.map(&complete_line/1)
      |> Enum.map(&calculate_auto_complete_score/1)
      |> find_middle_score()

    Logger.info("The middle score is #{result}")
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

  defp complete_line(line) do
    line
    |> Enum.reduce([], fn symbol, list ->
      closer = Map.get(@brackets, symbol)
      list ++ [closer]
    end)
  end

  defp calculate_auto_complete_score(closing_chars) do
    closing_chars
    |> Enum.reduce(0, fn char, sum ->
      sum * 5 + point(char, :incomplete)
    end)
  end

  defp find_middle_score(scores) do
    size = length(scores)

    scores
    |> Enum.sort()
    |> Enum.at((size / 2) |> trunc)
  end

  defp pop([]), do: {nil, []}
  defp pop(stack), do: {hd(stack), tl(stack)}

  defp close?(char) do
    char in ~w(\) } ] >)
  end

  defp closing?(right, left), do: Map.get(@brackets, left) == right

  defp point(")", :corrupt), do: 3
  defp point("]", :corrupt), do: 57
  defp point("}", :corrupt), do: 1197
  defp point(">", :corrupt), do: 25137

  defp point(")", :incomplete), do: 1
  defp point("]", :incomplete), do: 2
  defp point("}", :incomplete), do: 3
  defp point(">", :incomplete), do: 4
end
