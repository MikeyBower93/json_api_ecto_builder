defmodule JsonApiEctoBuilder.Applier.Filter do
  import Ecto.Query
  alias JsonApiEctoBuilder.ParamParser.Filter

  def apply(query, params, base_alias) do
    params
    |> Filter.parse(base_alias)
    |> Enum.reduce(query, &do_apply/2)
  end

  defp do_apply({field_param, :GT, value, binding}, query) do
    query
    |> where([{^binding, x}], field(x, ^field_param) > ^value)
  end

  defp do_apply({field_param, :GTE, value, binding}, query) do
    query
    |> where([{^binding, x}], field(x, ^field_param) >= ^value)
  end

  defp do_apply({field_param, :LT, value, binding}, query) do
    query
    |> where([{^binding, x}], field(x, ^field_param) < ^value)
  end

  defp do_apply({field_param, :LTE, value, binding}, query) do
    query
    |> where([{^binding, x}], field(x, ^field_param) <= ^value)
  end

  defp do_apply({field_param, :LK, value, binding}, query) do
    like_value = "%#{value}%"

    query
    |> where([{^binding, x}], like(field(x, ^field_param), ^like_value))
  end

  defp do_apply({field_param, :NEQ, value, binding}, query) do
    query
    |> where([{^binding, x}], field(x, ^field_param) != ^value)
  end

  defp do_apply({field_param, :EQ, value, binding}, query) do
    query
    |> where([{^binding, x}], field(x, ^field_param) == ^value)
  end

  defp do_apply({field_param, :IN, value, binding}, query) do
    in_value = String.split(value, ",")

    query
    |> where([{^binding, x}], field(x, ^field_param) in ^in_value)
  end
end
