defmodule Mix.Tasks.Process do
  use Mix.Task

  alias Model.World

  def run(_) do
    EXLA.Application.start(:any, :thing)

    world = Benchmark.measure(fn -> World.read() end, "read")
    schedule = Benchmark.measure(fn -> Schedule.build(world) end, "run")
    Benchmark.measure(fn -> Schedule.render(schedule) end, "render")
  end
end
