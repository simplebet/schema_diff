defmodule SchemaDiff do
  def file_to_schema(filename) do
    filename
    |> File.read!()
    |> parse()
    |> to_schema()
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

  def parse(data) when is_binary(data) do
    {data, _binding} = Code.eval_string(data)
    data
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
