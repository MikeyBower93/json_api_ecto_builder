defmodule JsonApiEctoBuilderTest.ApplierTests.SortTest do
  use ExUnit.Case

  import Ecto.Query

  alias JsonApiEctoBuilder.Applier.Sort
  alias JsonApiEctoBuilderTest.TestEntities.TestEntity

  setup do
    base_query = from t in TestEntity, as: :base_alias

    {:ok, base_query: base_query, base_alias: :base_alias, primary_key: :id}
  end

  #Test no sort

  test "test no sort", %{ base_query: base_query, base_alias: base_alias, primary_key: primary_key } do
    sort_param = %{
    }

    generated_query = Sort.apply(base_query, sort_param, base_alias,  primary_key)

    expected_query =
      from t0 in base_query,
      distinct: [asc: t0.id],
      select: %{id: t0.id, ordinal: over(row_number(), order_by: [asc: t0.id])}

    assert inspect(generated_query) == inspect(expected_query)

  end

  test "test single sort", %{ base_query: base_query, base_alias: base_alias, primary_key: primary_key } do
    sort_param = %{
      "sort" => "x"
    }

    generated_query = Sort.apply(base_query, sort_param, base_alias,  primary_key)

    expected_query =
      from t0 in base_query,
      windows: [w: [order_by: [asc: t0.x]]],
      distinct: [asc: t0.id],
      select: %{id: t0.id, ordinal: over(row_number(), :w)}

    assert inspect(generated_query) == inspect(expected_query)
  end

  test "test multiple sort", %{ base_query: base_query, base_alias: base_alias, primary_key: primary_key } do
    sort_param = %{
      "sort" => "x,y"
    }

    generated_query = Sort.apply(base_query, sort_param, base_alias,  primary_key)

    expected_query =
      from t0 in base_query,
      windows: [w: [order_by: [asc: t0.x, asc: t0.y]]],
      distinct: [asc: t0.id],
      select: %{id: t0.id, ordinal: over(row_number(), :w)}

    assert inspect(generated_query) == inspect(expected_query)
  end

  test "test desc sort", %{ base_query: base_query, base_alias: base_alias, primary_key: primary_key } do
    sort_param = %{
      "sort" => "-x"
    }

    generated_query = Sort.apply(base_query, sort_param, base_alias,  primary_key)

    expected_query =
      from t0 in base_query,
      windows: [w: [order_by: [desc: t0.x]]],
      distinct: [asc: t0.id],
      select: %{id: t0.id, ordinal: over(row_number(), :w)}

    assert inspect(generated_query) == inspect(expected_query)
  end
end
