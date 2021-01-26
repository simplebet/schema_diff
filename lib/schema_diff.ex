defmodule SchemaDiff do
  def file_to_schema(filename) do
    filename
    |> File.read!()
    |> parse(Path.extname(filename))
    |> Jason.encode!(pretty: true)
  end

  @doc """

  iex> pairs([:a, :b, :c])
  [{:a, :b}, {:a, :c}, {:b, :c}]
  """
  def pairs([]), do: []
  def pairs([_]), do: []

  def pairs([first | rest]) do
    Enum.zip(Stream.repeatedly(fn -> first end), rest) ++ pairs(rest)
  end

  def parse(data, ext) when ext in [".ex", ".exs"] do
    {data, _binding} = Code.eval_string(data)
    to_schema(data)
  end

  def parse(data, ".json") do
    data |> Jason.decode!(keys: :atoms) |> to_schema()
  end

  def parse(data, ".schema") do
    data |> Jason.decode!(keys: :atoms) |> parse_schema()
  end

  defp parse_schema(list) when is_list(list) do
    Enum.map(list, &parse_schema/1)
  end

  defp parse_schema(data) when is_map(data) do
    for {k, v} <- data, into: %{} do
      {k, parse_schema(v)}
    end
  end

  defp parse_schema(v) do
    case v do
      "null" -> nil
      n when is_number(n) -> :number
      s when is_binary(s) -> String.to_existing_atom(s)
    end
  end

  def to_schema([]), do: %{type: :list, sub_type: :unknown}
  def to_schema([v | _rest]), do: %{type: :list, sub_type: to_schema(v)}

  def to_schema(data) when is_map(data) do
    %{
      type: :object,
      sub_type:
        Enum.reduce(data, %{}, fn {k, v}, schema ->
          Map.put(schema, k, to_schema(v))
        end)
    }
  end

  def to_schema(v) do
    cond do
      is_number(v) -> :number
      is_binary(v) -> :string
      is_nil(v) -> nil
      true -> :unknown
    end
  end
end
