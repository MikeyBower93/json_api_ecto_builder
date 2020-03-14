defmodule JsonApiEctoBuilder.Applier.Sort do
  import Ecto.Query
  alias JsonApiEctoBuilder.ParamParser.Sort

  def apply(query, %{ "sort" => _ } = param, base_alias, primary_key) do
    order_by =
      param
      |> Sort.parse(base_alias)
      |> Enum.reduce([], fn
          {field, :asc, binding}, orders ->
            orders ++ [asc: dynamic([{^binding, x}], field(x, ^field))]
          {field, :desc, binding}, orders ->
            orders ++ [desc: dynamic([{^binding, x}], field(x, ^field))]
          end)

    from x in query,
    windows: [w: [order_by: ^order_by]],
    select: %{id: field(x, ^primary_key), ordinal: row_number() |> over(:w)},
    distinct: field(x, ^primary_key)
  end

  def apply(query, _, _, primary_key) do
    from x in query,
    select: %{id: field(x, ^primary_key), ordinal: row_number() |> over(order_by: x.id)},
    distinct: field(x, ^primary_key)
  end
end
