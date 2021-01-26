defmodule Mix.Tasks.Schema.DiffAll do
  use Mix.Task

  @impl Mix.Task
  def run([directory]) do
    directory
    |> File.ls!()
    |> IO.inspect()
    |> SchemaDiff.pairs()
    |> Enum.each(fn {a, b} ->
      # TODO
      # Mix.Task.run()
      :ok
    end)
  end

  def run(_args) do
    IO.puts("mix schema.diff_all <directory>")
  end
end
