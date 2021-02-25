defmodule Benchmark do
  def measure(function, tag) do
    IO.puts("[#{tag}] started")
    {time, result} = :timer.tc(function)
    IO.puts("[#{tag}] finished #{time / 1_000_000}s")
    result
  end
end
