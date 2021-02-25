defmodule Mix.Tasks.Process do
  use Mix.Task

  alias Model.World

  def run(_) do
    world = Benchmark.measure(fn -> World.read() end, "read")

    world =
      Benchmark.measure(
        fn -> World.remove_unused_streets(world) end,
        "remove_unused_streets"
      )

    schedule = Benchmark.measure(fn -> Schedule.build(world) end, "run")
    Benchmark.measure(fn -> Schedule.render(schedule) end, "render")
  end
end
