defmodule Parallel do
  def pmap(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&(Task.await(&1, :infinity)))
  end

  def chunk_pmap(collection, factor, func) do
    chunk_size = Float.ceil(Enumerable.count(collection) / factor) |> trunc()

    collection
    |> Enum.chunk_every(chunk_size)
    |> pmap(fn chunk ->
      Enum.map(chunk, func)
    end)
    |> Enum.concat()
  end
end
