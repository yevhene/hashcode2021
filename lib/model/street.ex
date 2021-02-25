defmodule Model.Street do
  defstruct [:start, :finish, :name, :length]

  alias Model.Street

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
end
