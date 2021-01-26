defmodule SchemaDiffTest do
  use ExUnit.Case
  doctest SchemaDiff, import: true

  test "parse/1 can ingest elixir terms" do
    assert SchemaDiff.parse("%{a: 1}", ".ex") == %{type: :object, sub_type: %{a: :number}}
    assert SchemaDiff.parse("%{a: 1}", ".exs") == %{type: :object, sub_type: %{a: :number}}
  end

  test "parse/1 can ingest json" do
    assert SchemaDiff.parse(~S({"a": 1}), ".json") == %{type: :object, sub_type: %{a: :number}}
  end

  test "parse/1 can ingest schemas" do
    assert SchemaDiff.parse(~S({"type": "object", "sub_type": {"a": "number"}}), ".schema") == %{
             type: :object,
             sub_type: %{a: :number}
           }
  end

  test "to_schema/1 converts elixir terms to a schema" do
    assert SchemaDiff.to_schema(%{a: 1}) == %{type: :object, sub_type: %{a: :number}}

    assert SchemaDiff.to_schema(%{a: 1, b: %{c: "hello", d: nil}}) ==
             %{
               type: :object,
               sub_type: %{
                 a: :number,
                 b: %{
                   type: :object,
                   sub_type: %{
                     c: :string,
                     d: nil
                   }
                 }
               }
             }

    assert SchemaDiff.to_schema(%{a: 1, b: 2}) == SchemaDiff.to_schema(%{b: 2, a: 1})

    assert SchemaDiff.to_schema(%{a: [1, 2, 3]}) == %{
             type: :object,
             sub_type: %{a: %{type: :list, sub_type: :number}}
           }

    assert SchemaDiff.to_schema(%{a: [%{b: "b"}, %{b: "b"}]}) ==
             %{
               type: :object,
               sub_type: %{a: %{type: :list, sub_type: %{type: :object, sub_type: %{b: :string}}}}
             }
  end

  test "pairs/1 returns a list of all file pairs to diff" do
    assert SchemaDiff.pairs([:a]) == []
    assert SchemaDiff.pairs([:a, :b]) == [{:a, :b}]
    assert SchemaDiff.pairs([:a, :b, :c]) == [{:a, :b}, {:a, :c}, {:b, :c}]

    assert SchemaDiff.pairs([:a, :b, :c, :d]) == [
             {:a, :b},
             {:a, :c},
             {:a, :d},
             {:b, :c},
             {:b, :d},
             {:c, :d}
           ]
  end
end
