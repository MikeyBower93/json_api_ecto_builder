defmodule JsonApiEctoBuilder.QueryBuilder do
  import Ecto.Query

  alias JsonApiEctoBuilder.Applier.{Filter,Join,Sort,Include}

  def build_query(base_query, base_type, base_alias, params, apply_join_callback) do
    [primary_key] = base_type.__schema__(:primary_key)

    #TODO: get this into a github repository
    #TODO: they must! prebuild the request - test
    #TODO: unit tests
    #TODO: suggest skriviner for pagination, why reinvent a good horse, and ja_serializer for view renders etc
    #TODO: comment functions
    #TODO: parse out the params before they go to the appliers for better hierarchy
    #TODO: can probably use https://hexdocs.pm/plug/Plug.Parsers.html to build the query for unit tests
    #TODO: finish cleaning up, test in rocket library, put in github, start unit testing heavily
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
