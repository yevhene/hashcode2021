defmodule Benchmark do
  def measure(function, tag, out \\ :stderr) do
    IO.puts(out, "[#{tag}] started")
    {time, result} = :timer.tc(function)
    IO.puts(out, "[#{tag}] finished #{time / 1_000_000}s")
    result
  end
end
