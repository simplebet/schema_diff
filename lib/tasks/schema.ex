defmodule Mix.Tasks.Schema do
  use Mix.Task

  @impl Mix.Task
  def run([filename]) do
    filename |> SchemaDiff.file_to_schema() |> IO.puts()
  end

  def run(_args) do
    IO.puts("mix schema <file one>")
  end
end
