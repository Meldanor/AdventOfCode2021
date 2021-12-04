defmodule Mix.Tasks.Aoc do
  @moduledoc "Runs a challenge for a given day. `mix aoc <Day>`, starting with 1."
  @shortdoc "Echoes arguments"

  @challenges [&D01.Challenge.run/1]

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
