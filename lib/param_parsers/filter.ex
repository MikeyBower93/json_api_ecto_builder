defmodule JsonApiEctoBuilder.ParamParser.Filter do
  alias JsonApiEctoBuilder.ParamParser.Utilities

  def parse(params, base_alias) do
    params
    |> Map.get("filter")
    |> Utilities.maybe_map_to_list
    |> Enum.map(parse_from_param_closure(base_alias))
  end

  defp parse_from_param_closure(base_alias) do
    fn {field, value} ->

      { field, associations } =
        Utilities.parse_field_and_associations_from_param(field, base_alias)

      nested_association = Utilities.associations_list_to_named_binding(associations)

      operator = parse_operator(value)
      value = parse_value(value)

      { String.to_atom(field), operator, value, String.to_atom(nested_association) }
    end
  end

  defp parse_operator(value) when is_map(value) do
    [{operator, _}] =
      value
      |> Map.to_list

    String.to_atom(operator)
  end

  defp parse_operator(_) do
    :EQ
  end

  defp parse_value(value) when is_map(value) do
    [{_, required_value}] =
      value
      |> Map.to_list

    required_value
  end

  defp parse_value(value) do
    value
  end
end
