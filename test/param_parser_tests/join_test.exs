defmodule JsonApiEctoBuilderTest.ParamParserTests.JoinTest do
  use ExUnit.Case

  alias JsonApiEctoBuilder.ParamParser.Join

  test "Parse a single join from filter" do
    parse_result =
      %{ "filter" => %{"entity.name" => "Hello" } }
      |> Join.parse()

    assert parse_result == [:entity]
  end

  test "Parse a nested join from filter" do
    parse_result =
      %{ "filter" => %{"entity.entity2.name" => "Hello" } }
      |> Join.parse()

    assert parse_result == [:entity, :entity_entity2]
  end

  test "Parse a multiple join from filter" do
    parse_result =
      %{ "filter" => %{"entity.entity2.name" => "Hello", "otherentity.name" => "Temp" } }
      |> Join.parse()

    assert parse_result == [:entity, :entity_entity2, :otherentity]
  end

  test "Parse a colliding join from filter" do
    parse_result =
      %{ "filter" => %{"entity.entity2.name" => "Hello", "entity.name" => "Temp" } }
      |> Join.parse()

    assert parse_result == [:entity, :entity_entity2]
  end

  test "Parse a single join from sort" do
    parse_result =
      %{ "sort" => "entity.name" }
      |> Join.parse()

    assert parse_result == [:entity]
  end

  test "Parse a nested join from sort" do
    parse_result =
      %{ "sort" => "entity.entity2.name" }
      |> Join.parse()

    assert parse_result == [:entity, :entity_entity2]
  end

  test "Parse a multiple join from sort" do
    parse_result =
      %{ "sort" => "entity.entity2.name,otherentity.name" }
      |> Join.parse()

    assert parse_result == [:entity, :entity_entity2, :otherentity]
  end

  test "Parse a colliding join from sort" do
    parse_result =
      %{ "sort" => "entity.entity2.name,-entity.name" }
      |> Join.parse()

    assert parse_result == [:entity, :entity_entity2]
  end

  test "Parse a single join from sort and filter" do
    parse_result =
      %{ "filter" => %{ "entity.name" => "Hello" }, "sort" => "entity.sort" }
      |> Join.parse()

    assert parse_result == [:entity]
  end

  test "Parse a nested join from sort and filter" do
    parse_result =
      %{ "filter" => %{ "entity.entity2.name" => "Hello" }, "sort" => "entity.entity2.sort" }
      |> Join.parse()

    assert parse_result == [:entity, :entity_entity2]
  end

  test "Parse a a non collision from sort and filter" do
    parse_result =
      %{ "filter" => %{ "entity.entity2.name" => "Hello" }, "sort" => "sort.sort2.sort" }
      |> Join.parse()

    assert parse_result == [:entity, :entity_entity2, :sort, :sort2]
  end
end
