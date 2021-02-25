defmodule Model.World do
  defstruct [
    :bonus,
    :duration,
    :cars,
    :intersections_count,
    :streets
  ]

  alias Model.Car
  alias Model.Street
  alias Model.World

  def read do
    [duration, intersections_count, streets_count, cars_count, bonus] =
      read_header()

    streets = Enum.map(1..streets_count, fn _ -> Street.read() end)
    cars = Enum.map(1..cars_count, fn _ -> Car.read() end)

    %World{
      bonus: bonus,
      duration: duration,
      cars: cars,
      intersections_count: intersections_count,
      streets: streets
    }
  end

  defp read_header do
    IO.read(:stdio, :line)
    |> String.split([" ", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def remove_unused_streets(%World{} = world) do
    used_streets =
      world.cars
      |> Enum.reduce(MapSet.new(), fn %Car{route: route}, set ->
        route |> MapSet.new() |> MapSet.union(set)
      end)

    streets =
      world.streets
      |> Enum.filter(fn %Street{name: name} ->
        MapSet.member?(used_streets, name)
      end)

    %{world | streets: streets}
  end

  # Intersections IO K
  def io_k(%World{} = world) do
    0..(world.intersections_count - 1)
    |> Enum.map(fn intersection ->
      ins = length(Street.incoming(world, intersection))
      outs = length(Street.outcoming(world, intersection))

      if ins == 0 || outs == 0, do: 0.0, else: ins
    end)
  end

  # Streets Cars K
  def cars_k(%World{} = world) do
    world.streets
    |> Enum.reduce(%{}, fn %Street{name: name}, acc ->
      k =
        world.cars
        |> Enum.filter(fn %Car{route: route} -> Enum.member?(route, name) end)
        |> length()

      Map.put(acc, name, k)
    end)
  end
end
