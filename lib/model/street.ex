defmodule Model.Street do
  defstruct [:start, :finish, :name, :length]

  alias Model.Street
  alias Model.World

  def read do
    [start, finish, name, length] =
      IO.read(:stdio, :line)
      |> String.split([" ", "\n"], trim: true)

    %Street{
      start: String.to_integer(start),
      finish: String.to_integer(finish),
      name: name,
      length: String.to_integer(length)
    }
  end

  def incoming(%World{} = world, intersection) do
    world.streets
    |> Enum.filter(fn %Street{finish: finish} -> finish == intersection end)
  end

  def outcoming(%World{} = world, intersection) do
    world.streets
    |> Enum.filter(fn %Street{start: start} -> start == intersection end)
  end
end
