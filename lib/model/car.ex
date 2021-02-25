defmodule Model.Car do
  defstruct [:route]

  alias Model.Car

  def read do
    [route_length | route] =
      IO.read(:stdio, :line)
      |> String.split([" ", "\n"], trim: true)

    route_length = String.to_integer(route_length)
    ^route_length = length(route)

    %Car{route: route}
  end
end
