defmodule JsonApiEctoBuilder.Applier.Join do
  import Ecto.Query
  alias JsonApiEctoBuilder.ParamParser.Join

  def apply(query, params, apply_join_callback) do
    params
    |> Join.parse
    |> Enum.reduce(query, fn join, query ->
      case has_named_binding?(query, join) do
        true ->
          query
        false ->
          apply_join_callback.(join, query)
      end
    end)
  end
end
