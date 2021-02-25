defmodule Schedule do
  alias Model.Car
  alias Model.Street
  alias Model.World

  def build(%World{} = world) do
    cache = build_cache(world)

    0..(world.intersections_count - 1)
    |> Enum.map(fn intersection ->
      {intersection, build_intersection_schedule(world, intersection, cache)}
    end)
    |> Enum.filter(fn {_intersection, intersection_schedule} ->
      length(intersection_schedule) > 0
    end)
  end

  defp build_cache(%World{} = world) do
    %{used_streets: used_streets(world)}
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

  defp used_streets(%World{cars: cars}) do
    cars
    |> Enum.reduce(MapSet.new(), fn %Car{route: route}, set ->
      route |> MapSet.new() |> MapSet.union(set)
    end)
  end

  defp build_intersection_schedule(%World{} = world, intersection, cache) do
    incoming_streets(world, intersection, cache)
    |> Enum.map(fn %Street{name: name} -> {name, 1} end)
  end

  defp incoming_streets(%World{} = world, intersection, cache) do
    world.streets
    |> Enum.filter(fn %Street{finish: finish} ->
      finish == intersection
    end)
    |> Enum.filter(fn %Street{name: name} ->
      MapSet.member?(cache[:used_streets], name)
    end)
  end
end
