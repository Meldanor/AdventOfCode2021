defmodule Mix.Tasks.Aoc do
  @moduledoc "Runs a challenge for a given day. `mix aoc <Day (1-24)> <Challenge (1-2)>`"
  @shortdoc "Echoes arguments"

  @challenges [
    &D01.Challenge.run/1,
    &D02.Challenge.run/1,
    &D03.Challenge.run/1,
    &D04.Challenge.run/1,
    &D05.Challenge.run/1,
    &D06.Challenge.run/1
  ]

  use Mix.Task

  require Logger

  @impl Mix.Task
  def run(args) do
    day = Enum.at(args, 0) |> String.to_integer()
    challenge_index = Enum.at(args, 1) |> String.to_integer()
    challenge = Enum.at(@challenges, day - 1)
    Logger.info("Day #{day} Challenge #{challenge_index}")
    challenge.(challenge_index)
  end
end
