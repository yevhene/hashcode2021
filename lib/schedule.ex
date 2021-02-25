defmodule Schedule do
  alias Model.Car
  alias Model.Street
  alias Model.World

  def build(%World{} = world) do
    0..(world.intersections_count - 1)
    |> Enum.map(fn intersection ->
      {intersection, build_intersection_schedule(world, intersection)}
    end)
  end

  def render(schedule, out \\ :stdio) do
    IO.puts(out, length(schedule))
    Enum.each(schedule, fn {intersection, intersection_schedule} ->
      IO.puts(out, intersection)
      IO.puts(out, length(intersection_schedule))
      Enum.each(intersection_schedule, fn {street_name, time} ->
        IO.puts(out, "#{street_name} #{time}")
      end)
    end)
  end

  defp build_intersection_schedule(%World{} = world, intersection) do
    incoming_streets(world, intersection)
    |> Enum.map(fn %Street{name: name} -> {name, 1} end)
  end

  defp incoming_streets(%World{} = world, intersection) do
    world.streets
    |> Enum.filter(fn %Street{finish: finish} ->
      finish == intersection
    end)
    |> Enum.filter(fn %Street{name: name} ->
      Enum.any?(world.cars, fn %Car{route: route} ->
        Enum.member?(route, name)
      end)
    end)
  end
end
