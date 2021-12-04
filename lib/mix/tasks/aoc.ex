defmodule Mix.Tasks.Aoc do
  @moduledoc "Runs a challenge for a given day. `mix aoc <Day>`, starting with 1."
  @shortdoc "Echoes arguments"

  @challenges [&D01.Challenge.run/0]

  use Mix.Task

  require Logger

  @impl Mix.Task
  def run(args) do
    day = Enum.at(args, 0) |> String.to_integer()
    challenge = Enum.at(@challenges, day - 1)
    Logger.info("Executing challenge of day #{day}")
    challenge.()
  end
end
