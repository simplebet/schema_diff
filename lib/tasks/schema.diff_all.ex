defmodule Mix.Tasks.Schema.DiffAll do
  use Mix.Task

  @impl Mix.Task
  def run([directory]) do
    directory
    |> File.ls!()
    |> Enum.map(&Path.join(directory, &1))
    |> SchemaDiff.pairs()
    |> Enum.each(fn {a, b} ->
      Mix.Task.reenable("schema.diff")
      Mix.Task.run("schema.diff", [a, b])
    end)
  end

  def run(_args) do
    IO.puts("mix schema.diff_all <directory>")
  end
end
