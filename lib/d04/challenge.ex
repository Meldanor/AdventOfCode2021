defmodule D04.Challenge do
  @moduledoc false

  require Logger

  def run(1) do
    lines = Utils.read_input(4)
    bingo_numbers = lines |> Enum.at(0) |> String.split(",") |> Enum.map(&String.to_integer/1)
    boards = parse_boards(lines)

    # Go through the numbers until the first board has enough numbers marked
    {winner, last_number} =
      Enum.reduce_while(bingo_numbers, boards, fn number, boards ->
        boards = mark_number_on_boards(boards, number)
        winner = find_winner(boards)
        if winner, do: {:halt, {winner, number}}, else: {:cont, boards}
      end)

    Logger.info("Winning score: #{calculate_winner_score(winner, last_number)}")
  end

  def run(2) do
    lines = Utils.read_input(4)
    bingo_numbers = lines |> Enum.at(0) |> String.split(",") |> Enum.map(&String.to_integer/1)
    init_boards = parse_boards(lines)

    # Go through the numbers until only one board exists and has won
    {winner, last_number} =
      Enum.reduce_while(bingo_numbers, init_boards, fn number, boards ->
        boards = mark_number_on_boards(boards, number)
        winners = find_winners(boards)

        # No winner? Resume as usual
        if Enum.empty?(winners) do
          {:cont, boards}
        else
          # Only one board and it has won? Halt the loop
          if length(boards) == 1 do
            {:halt, {hd(winners), number}}
            # Multiple winners? Remove their boards
          else
            boards = Enum.reject(boards, fn board -> board in winners end)
            {:cont, boards}
          end
        end
      end)

    Logger.info("Winning score: #{calculate_winner_score(winner, last_number)}")
  end

  defp parse_boards(lines) do
    lines
    |> tl()
    |> Enum.chunk_every(5)
    |> Enum.map(&Enum.join(&1, " "))
    |> Enum.map(&String.split/1)
    |> Enum.map(fn board ->
      Enum.map(board, &String.to_integer/1) |> Enum.map(fn val -> %{marked: false, val: val} end)
    end)
  end

  defp row(board, row_index) do
    Enum.slice(board, row_index * 5, 5)
  end

  defp column(board, column_index) do
    Enum.slice(board, column_index..-1)
    |> Enum.take_every(5)
  end

  defp mark_number_on_boards(boards, number) do
    boards
    |> Enum.map(fn board ->
      Enum.map(board, fn board_number ->
        if board_number.val == number,
          do: Map.put(board_number, :marked, true),
          else: board_number
      end)
    end)
  end

  defp find_winner(boards) do
    boards
    |> Enum.find(&won?/1)
  end

  defp find_winners(boards) do
    boards
    |> Enum.filter(&won?/1)
  end

  defp won?(board) do
    row_bingo = Enum.any?(0..4, fn row -> row(board, row) |> bingo? end)
    col_bingo = Enum.any?(0..4, fn col -> column(board, col) |> bingo? end)
    row_bingo or col_bingo
  end

  defp bingo?(numbers) do
    Enum.all?(numbers, fn val -> val.marked end)
  end

  defp calculate_winner_score(winner_board, last_number) do
    winner_board
    |> Enum.reject(fn val -> val.marked end)
    |> Enum.map(fn val -> val.val end)
    |> Enum.sum()
    |> Kernel.*(last_number)
  end
end
