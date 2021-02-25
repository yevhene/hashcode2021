defmodule Schedule do
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
    %{intersections_k: intersections_k(world)}
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

  defp intersections_k(%World{} = world) do
    0..(world.intersections_count - 1)
    |> Enum.map(fn intersection ->
      ins = length(incoming_streets(world, intersection))
      outs = length(outcoming_streets(world, intersection))

      if ins == 0 || outs == 0, do: 0.0, else: ins / outs
    end)
  end

  defp build_intersection_schedule(%World{} = world, intersection, cache) do
    incoming_streets(world, intersection)
    |> Enum.map(fn %Street{name: name, start: start} ->
      {name,
       cache[:intersections_k] |> Enum.at(start) |> Float.ceil() |> trunc()}
    end)
    |> Enum.filter(fn {_name, sec} -> sec > 0 end)
  end

  defp incoming_streets(%World{} = world, intersection) do
    world.streets
    |> Enum.filter(fn %Street{finish: finish} -> finish == intersection end)
  end

  defp outcoming_streets(%World{} = world, intersection) do
    world.streets
    |> Enum.filter(fn %Street{start: start} -> start == intersection end)
  end
end
