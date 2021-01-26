defmodule Mix.Tasks.Schema do
  use Mix.Task

  @impl Mix.Task
  def run([filename]) do
    filename |> SchemaDiff.file_to_schema() |> Mix.shell().info()
  end

  def run(_args) do
    Mix.shell().error("mix schema <file one>")
  end
end
