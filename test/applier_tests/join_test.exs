defmodule JsonApiEctoBuilderTest.ApplierTests.JoinTest do
  use ExUnit.Case

  import Ecto.Query

  alias JsonApiEctoBuilder.Applier.Join
  alias JsonApiEctoBuilderTest.TestEntities.TestEntity

  setup do
    base_query = from t in TestEntity, as: :base_alias

    {:ok, base_query: base_query}
  end

  test "test single join entity", %{ base_query: base_query } do
    filter_param = %{
      "filter" => %{
        "entity.x" => 1
      }
    }

    applier = fn :entity, query ->
      query
      |> join(:inner, [base_alias: x], assoc(x, :entity), as: :entity)
    end

    generated_query = Join.apply(base_query, filter_param, applier)

    expected_query =
      base_query
      |> join(:inner, [base_alias: x], assoc(x, :entity), as: :entity)

    assert inspect(generated_query) == inspect(expected_query)
  end

  test "test nested join entity", %{ base_query: base_query } do
    filter_param = %{
      "filter" => %{
        "entity.entity.x" => 1
      }
    }

    applier = fn
      :entity, query ->
        query |> join(:inner, [base_alias: x], assoc(x, :entity), as: :entity)
      :entity_entity, query ->
        query |> join(:inner, [entity: x], assoc(x, :entity), as: :entity_entity)
    end

    generated_query = Join.apply(base_query, filter_param, applier)

    expected_query =
      base_query
      |> join(:inner, [base_alias: x], assoc(x, :entity), as: :entity)
      |> join(:inner, [entity: x], assoc(x, :entity), as: :entity_entity)

    assert inspect(generated_query) == inspect(expected_query)
  end

  test "test nested seperate join entity", %{ base_query: base_query } do
    filter_param = %{
      "filter" => %{
        "entity.entity.x" => 1
      },
      "sort" => "second.second.y"
    }

    applier = fn
      :entity, query ->
        query |> join(:inner, [base_alias: x], assoc(x, :entity), as: :entity)
      :entity_entity, query ->
        query |> join(:inner, [entity: x], assoc(x, :entity), as: :entity_entity)
      :second, query ->
        query |> join(:inner, [base_alias: x], assoc(x, :second), as: :second)
      :second_second, query ->
        query |> join(:inner, [second: x], assoc(x, :second), as: :second_second)
    end

    generated_query = Join.apply(base_query, filter_param, applier)

    expected_query =
      base_query
      |> join(:inner, [base_alias: x], assoc(x, :entity), as: :entity)
      |> join(:inner, [entity: x], assoc(x, :entity), as: :entity_entity)
      |> join(:inner, [base_alias: x], assoc(x, :second), as: :second)
      |> join(:inner, [second: x], assoc(x, :second), as: :second_second)

    assert inspect(generated_query) == inspect(expected_query)
  end
end
