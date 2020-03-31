defmodule JsonApiEctoBuilderTest.ParamParserTests.SortTest do
  use ExUnit.Case

  alias JsonApiEctoBuilder.ParamParser.Sort

  test "Parse an empty sort" do
    parse_result =
      %{"sort" => ""}
      |> Sort.parse(:base_alias)

    assert parse_result == []
  end

  test "Parse a single sort" do
    parse_result =
      %{"sort" => "name"}
      |> Sort.parse(:base_alias)

    assert parse_result == [{:name, :asc, :base_alias}]
  end

  test "Parse a nested single sort" do
    parse_result =
      %{"sort" => "entity.name"}
      |> Sort.parse(:base_alias)

    assert parse_result == [{:name, :asc, :entity}]
  end

  test "Parse a multiple sort" do
    parse_result =
      %{"sort" => "entity.name,age,entity.entity2.date"}
      |> Sort.parse(:base_alias)

    assert parse_result == [
             {:name, :asc, :entity},
             {:age, :asc, :base_alias},
             {:date, :asc, :entity_entity2}
           ]
  end

  test "Parse a base descending sort" do
    parse_result =
      %{"sort" => "-age"}
      |> Sort.parse(:base_alias)

    assert parse_result == [
             {:age, :desc, :base_alias}
           ]
  end

  test "Parse a nested descending sort" do
    parse_result =
      %{"sort" => "-entity.age"}
      |> Sort.parse(:base_alias)

    assert parse_result == [
             {:age, :desc, :entity}
           ]
  end
end
