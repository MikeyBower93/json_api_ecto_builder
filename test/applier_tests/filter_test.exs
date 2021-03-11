defmodule JsonApiEctoBuilderTest.ApplierTests.FilterTest do
  use ExUnit.Case

  import Ecto.Query

  alias JsonApiEctoBuilder.Applier.Filter
  alias JsonApiEctoBuilderTest.TestEntities.TestEntity

  setup do
    base_query = from t in TestEntity, as: :base_alias

    {:ok, base_query: base_query, base_alias: :base_alias}
  end

  test "test single filter no operator", %{ base_query: base_query, base_alias: base_alias } do
    filter_param = %{
      "filter" => %{
        "x" => "value"
      }
    }

    generated_query = Filter.apply(base_query, filter_param, base_alias)

    expected_query =
      from t0 in base_query,
      where: t0.x == ^"value"

    assert inspect(generated_query) == inspect(expected_query)
  end

  test "test single filter equal operator", %{ base_query: base_query, base_alias: base_alias } do
    filter_param = %{
      "filter" => %{
        "x" => %{
          "EQ" => "value"
        }
      }
    }

    generated_query = Filter.apply(base_query, filter_param, base_alias)

    expected_query =
      from t0 in base_query,
      where: t0.x == ^"value"

    assert inspect(generated_query) == inspect(expected_query)
  end

  test "test single filter not equal operator", %{ base_query: base_query, base_alias: base_alias } do
    filter_param = %{
      "filter" => %{
        "x" => %{
          "NEQ" => "value"
        }
      }
    }

    generated_query = Filter.apply(base_query, filter_param, base_alias)

    expected_query =
      from t0 in base_query,
      where: t0.x != ^"value"

    assert inspect(generated_query) == inspect(expected_query)
  end

  test "test single filter like operator", %{ base_query: base_query, base_alias: base_alias } do
    filter_param = %{
      "filter" => %{
        "x" => %{
          "LK" => "value"
        }
      }
    }

    generated_query = Filter.apply(base_query, filter_param, base_alias)

    expected_query =
      from t0 in base_query,
      where: like(t0.x, ^"%value%")

    assert inspect(generated_query) == inspect(expected_query)
  end

  test "test single filter less than or equal operator", %{ base_query: base_query, base_alias: base_alias } do
    filter_param = %{
      "filter" => %{
        "x" => %{
          "LTE" => 2
        }
      }
    }

    generated_query = Filter.apply(base_query, filter_param, base_alias)

    expected_query =
      from t0 in base_query,
      where: t0.x <= ^2

    assert inspect(generated_query) == inspect(expected_query)
  end

  test "test single filter less than operator", %{ base_query: base_query, base_alias: base_alias } do
    filter_param = %{
      "filter" => %{
        "x" => %{
          "LT" => 2
        }
      }
    }

    generated_query = Filter.apply(base_query, filter_param, base_alias)

    expected_query =
      from t0 in base_query,
      where: t0.x < ^2

    assert inspect(generated_query) == inspect(expected_query)
  end

  test "test single filter greater than or equal operator", %{ base_query: base_query, base_alias: base_alias } do
    filter_param = %{
      "filter" => %{
        "x" => %{
          "GTE" => 2
        }
      }
    }

    generated_query = Filter.apply(base_query, filter_param, base_alias)

    expected_query =
      from t0 in base_query,
      where: t0.x >= ^2

    assert inspect(generated_query) == inspect(expected_query)
  end

  test "test single filter greater than operator", %{ base_query: base_query, base_alias: base_alias } do
    filter_param = %{
      "filter" => %{
        "x" => %{
          "GT" => 2
        }
      }
    }

    generated_query = Filter.apply(base_query, filter_param, base_alias)

    expected_query =
      from t0 in base_query,
      where: t0.x > ^2

    assert inspect(generated_query) == inspect(expected_query)
  end

  test "test single filter IN operator", %{ base_query: base_query, base_alias: base_alias } do
    filter_param = %{
      "filter" => %{
        "x" => %{
          "IN" => "1,2"
        }
      }
    }

    generated_query = Filter.apply(base_query, filter_param, base_alias)

    expected_query =
      from t0 in base_query,
      where: t0.x in ^["1","2"]

    assert inspect(generated_query) == inspect(expected_query)
  end

  test "test multiple filters", %{ base_query: base_query, base_alias: base_alias } do
    filter_param = %{
      "filter" => %{
        "x" => 1,
        "y" => 2
      }
    }

    generated_query = Filter.apply(base_query, filter_param, base_alias)

    expected_query =
      from t0 in base_query,
      where: t0.x == ^1,
      where: t0.y == ^2

    assert inspect(generated_query) == inspect(expected_query)
  end

  test "test multiple operators on same field", %{ base_query: base_query, base_alias: base_alias } do
    filter_param = %{
      "filter" => %{
        "x" => %{
          "GT" => 1,
          "LT" => 3
        }
      }
    }

    generated_query = Filter.apply(base_query, filter_param, base_alias)

    expected_query =
      from t0 in base_query,
      where: t0.x > ^1,
      where: t0.x < ^3

    assert inspect(generated_query) == inspect(expected_query)
  end

  test "test nested fields", %{ base_query: base_query, base_alias: base_alias } do
    filter_param = %{
      "filter" => %{
        "nested.x" => 1
      }
    }

    base_query =
      base_query
      |> join(:inner, [x], assoc(x, :nested), as: :nested)

    generated_query = Filter.apply(base_query, filter_param, base_alias)

    expected_query =
      from [t0, t1] in base_query,
      where: t1.x == ^1

    assert inspect(generated_query) == inspect(expected_query)
  end
end
