defmodule JsonApiEctoBuilderTest.ParamParserTests.IncludeTest do
  use ExUnit.Case

  alias JsonApiEctoBuilder.ParamParser.Include

  test "Parse a single include" do
    parse_result =
      %{ "include" => "entity" }
      |> Include.parse()

    assert parse_result == [:entity]
  end

  test "Parse multiple flat includes" do
    parse_result =
      %{ "include" => "entity,entity2,entity3" }
      |> Include.parse()

    assert parse_result == [:entity, :entity2, :entity3]
  end

  test "Parse nested associations" do
    parse_result =
      %{ "include" => "entity.entity2.entity3.entity4" }
      |> Include.parse()

    assert parse_result == [entity: [entity2: [entity3: [:entity4]]]]
  end

  test "Parse multiple nested associations" do
    parse_result =
      %{ "include" => "entity.entity2.entity3.entity4,multiple.multiple2.multiple3" }
      |> Include.parse()

    assert parse_result == [multiple: [multiple2: [:multiple3]], entity: [entity2: [entity3: [:entity4]]]]
  end

  test "Parse multiple colliding nested associations" do
    parse_result =
      %{ "include" => "entity.entity2.entity3.entity4,entity.entity2.entitynest3.entitynest4" }
      |> Include.parse()

    assert parse_result == [entity: [entity2: [entitynest3: [:entitynest4], entity3: [:entity4]]]]
  end

  test "Parse no includes" do
    parse_result =
      %{ }
      |> Include.parse()

    assert parse_result == []
  end
end
