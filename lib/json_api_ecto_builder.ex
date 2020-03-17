defmodule JsonApiEctoBuilder do
  import Ecto.Query

  alias JsonApiEctoBuilder.Applier.{Filter,Join,Sort,Include}

  def build_query(base_query, base_type, base_alias, params, apply_join_callback) do
    [primary_key] = base_type.__schema__(:primary_key)

    sub_query =
      base_query
      |> Join.apply(params, apply_join_callback)
      |> Filter.apply(params, base_alias)
      |> Sort.apply(params, base_alias, primary_key)

    base_type
    |> join(:inner, [b], s in subquery(sub_query), on: b.id == field(s, ^primary_key))
    |> order_by([_, x], x.ordinal)
    |> Include.apply(params)
  end
end
