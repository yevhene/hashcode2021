defmodule Schedule do
  alias Model.Street
  alias Model.World

  def build(%World{} = world) do
    cache = build_cache(world)

    0..(world.intersections_count - 1)
    |> Parallel.chunk_pmap(50, fn intersection ->
      {intersection, build_intersection_schedule(world, intersection, cache)}
    end)
    |> Enum.filter(fn {_intersection, intersection_schedule} ->
      length(intersection_schedule) > 0
    end)
  end

  defp build_cache(%World{} = world) do
    %{cars_k: World.cars_k(world)}
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

  defp build_intersection_schedule(%World{} = world, intersection, cache) do
    streets = Street.incoming(world, intersection)

    total_cars =
      streets
      |> Enum.reduce(0, fn %Street{name: name}, acc ->
        acc + cache[:cars_k][name]
      end)

    streets
    |> Enum.map(fn %Street{name: name} ->
      if total_cars > 0 && cache[:cars_k][name] > 0 do
        sec = part(7, cache[:cars_k][name] / total_cars)

        {name, sec}
      else
        {name, 0}
      end
    end)
    |> Enum.filter(fn {_name, sec} -> sec > 0 end)
  end

  defp part(total, k) do
    (total * k) |> Float.ceil() |> trunc()
  end
end
