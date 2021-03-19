defmodule JsonApiEctoBuilder do
  @moduledoc """
    The main module where you pass the query parameters through to build the query.

    Detailed documentation on the purpose behind the library and how to use it can be
    found here: https://github.com/MikeyBower93/json_api_ecto_builder
  """

  import Ecto.Query

  alias JsonApiEctoBuilder.Applier.{Filter,Join,Sort,Include}

  @doc """
  Call this function with a query, metadata about the base JSON API entity/type,
  the query parameters and a callback function for any joins necessary.
  """
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
