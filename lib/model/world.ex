defmodule Model.World do
  defstruct [
    :bonus,
    :duration,
    :cars,
    :cars_count,
    :intersections_count,
    :streets,
    :streets_count,
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
      cars_count: cars_count,
      intersections_count: intersections_count,
      streets: streets,
      streets_count: streets_count
    }
  end

  defp read_header do
    IO.read(:stdio, :line)
    |> String.split([" ", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
