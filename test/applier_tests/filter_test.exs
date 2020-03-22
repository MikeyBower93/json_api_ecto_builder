defmodule JsonApiEctoBuilderTest.ApplierTests.FilterTest do
  use ExUnit.Case

  import Ecto.Query

  alias JsonApiEctoBuilder.Applier.Filter

  test "test" do
    base = from t in TestEntity, as: :base_alias

    generated_query = Filter.apply(base, %{ "filter" => %{ "x" => %{ "GT" => "value", "LT" => "value2" } } }, :base_alias)

    expected_query =
      from t0 in TestEntity, as: :base_alias,
      where: t0.x > ^"value",
      where: t0.x < ^"value2"

    assert inspect(generated_query) == inspect(expected_query)
  end

  test "test flat" do
    base = from t in TestEntity, as: :base_alias

    generated_query = Filter.apply(base, %{ "filter" => %{ "x" => "value" } }, :base_alias)

    expected_query =
      from t0 in TestEntity, as: :base_alias,
      where: t0.x == ^"value"

    assert inspect(generated_query) == inspect(expected_query)
  end

  #TODO: to test ->
    # multiple on same field, ie < and > on date
    # testing that it generates for all permulations
    # generates a multi where query
    # flat request no operator filter
    # integration for results coming back
    # test that it works on with nested fields
    # we may in the future want to deal with NEQ and NEQ on the same field, or apply or filters (how would elixir parameters deal with this?)

    #Also need to make the entities more reusable

end

defmodule TestEntity do
  use Ecto.Schema

  schema "test_entity" do
    field :x, :string
    field :y, :string
  end
end
