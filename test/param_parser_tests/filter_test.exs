defmodule JsonApiEctoBuilderTest.ParamParserTests.FilterTest do
  use ExUnit.Case

  alias JsonApiEctoBuilder.ParamParser.Filter

  #TODO: Sort after change for multiple nested values
  #Also need to test them cases

  test "Parse a single base filter" do
    parse_result =
      %{ "filter" => %{"name" => "Hello" } }
      |> Filter.parse(:base_alias)

    assert parse_result == [{:name, :EQ, "Hello", :base_alias}]
  end

  test "Parse a single nested filter" do
    parse_result =
      %{ "filter" => %{"entity.name" => "Hello" } }
      |> Filter.parse(:base_alias)

    assert parse_result == [{:name, :EQ, "Hello", :entity}]
  end

  test "Parse a single deep nested filter" do
    parse_result =
      %{ "filter" => %{"entity.entity2.entity3.name" => "Hello" } }
      |> Filter.parse(:base_alias)

    assert parse_result == [{:name, :EQ, "Hello", :entity_entity2_entity3}]
  end

  test "Parse multiple base filter" do
    parse_result =
      %{ "filter" => %{"name" => "Hello", "age" => 23 } }
      |> Filter.parse(:base_alias)

    assert parse_result == [
      {:age, :EQ, 23, :base_alias},
      {:name, :EQ, "Hello", :base_alias}
    ]
  end

  test "Parse multiple nested filter" do
    parse_result =
      %{ "filter" => %{"entity1.name" => "Hello", "entity2.age" => 23 } }
      |> Filter.parse(:base_alias)

    assert parse_result == [
      {:name, :EQ, "Hello", :entity1},
      {:age, :EQ, 23, :entity2}
    ]
  end

  test "Parse operator" do
    parse_result =
      %{ "filter" => %{"name" => %{"TEST" => "Hello"} } }
      |> Filter.parse(:base_alias)

    assert parse_result == [
      {:name, :TEST, "Hello", :base_alias}
    ]
  end
end
