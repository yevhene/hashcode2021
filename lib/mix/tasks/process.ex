defmodule Mix.Tasks.Process do
  use Mix.Task

  alias Model.World

  def run(_) do
    EXLA.Application.start(:any, :thing)

    Benchmark.measure(fn -> World.read() end, "read")
    |> IO.inspect()
  end
end
