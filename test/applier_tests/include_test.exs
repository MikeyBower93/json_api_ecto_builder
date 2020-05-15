defmodule JsonApiEctoBuilderTest.ApplierTests.IncludeTest do
  use ExUnit.Case

  import Ecto.Query

  alias JsonApiEctoBuilder.Applier.Include
  alias JsonApiEctoBuilderTest.TestEntities.TestEntity

  setup do
    base_query = from t in TestEntity, as: :base_alias

    {:ok, base_query: base_query}
  end

  test "test single include entity", %{ base_query: base_query } do
    include_param = %{ "include" => "entity" }

    generated_query = Include.apply(base_query, include_param)

    preloads = [:entity]

    expected_query =
      base_query
      |> preload(^preloads)

    assert inspect(generated_query) == inspect(expected_query)
  end

  test "test single include nested entity", %{ base_query: base_query } do
    include_param = %{ "include" => "entity.entity.entity" }

    generated_query = Include.apply(base_query, include_param)

    preloads = [entity: [entity: [:entity]]]

    expected_query =
      base_query
      |> preload(^preloads)

    assert inspect(generated_query) == inspect(expected_query)
  end

  test "test multiple flat entities", %{ base_query: base_query } do
    include_param = %{ "include" => "entity,second_nested" }

    generated_query = Include.apply(base_query, include_param)

    preloads = [:entity, :second_nested]

    expected_query =
      base_query
      |> preload(^preloads)

    assert inspect(generated_query) == inspect(expected_query)
  end

  test "test multiple nested entities", %{ base_query: base_query } do
    include_param = %{ "include" => "entity.entity.entity,second_nested.entity" }

    generated_query = Include.apply(base_query, include_param)

    preloads = [second_nested: [:entity], entity: [entity: [:entity]]]

    expected_query =
      base_query
      |> preload(^preloads)

    assert inspect(generated_query) == inspect(expected_query)
  end

  test "test no includes doesn't have a preload" , %{ base_query: base_query } do
    generated_query = Include.apply(base_query, %{})

    expected_query = base_query

    assert inspect(generated_query) == inspect(expected_query)
  end
end
