defmodule SchemaDiff.TasksTest do
  use ExUnit.Case

  setup do
    dir = System.tmp_dir!()

    files = [
      gen_file(dir, "one", :json, %{a: 1}),
      gen_file(dir, "two", :elixir, %{a: 2})
    ]

    on_exit(fn ->
      Enum.each(files, &File.rm/1)
    end)

    %{files: files}
  end

  @tag :skip
  test "it diffs", %{files: files} do
    Mix.Task.run("schema.diff", files)
    assert_received {:mix_shell, :info, [diff]}
  end

  defp gen_file(dir, name, :json, data) do
    output(Path.join(dir, name <> ".json"), Jason.encode!(data))
  end

  defp gen_file(dir, name, :elixir, data) do
    output(Path.join(dir, name <> ".exs"), inspect(data))
  end

  defp output(filename, data) do
    File.write!(filename, data)
    filename
  end
end
