defmodule JsonApiEctoBuilder.ParamParser.Sort do
  alias JsonApiEctoBuilder.ParamParser.Utilities

  def parse(params, base_alias) do
    params
    |> Map.get("sort")
    |> Utilities.maybe_string()
    |> String.split(",")
    |> Utilities.handle_empty_list()
    |> Enum.map(parse_from_param_closure(base_alias))
  end

  def parse_from_param_closure(base_alias) do
    fn param ->
      {direction, param} = Utilities.get_sort_direction(param)

      {field, associations} = Utilities.parse_field_and_associations_from_param(param, base_alias)

      nested_association = Utilities.associations_list_to_named_binding(associations)

      {String.to_existing_atom(field), direction, String.to_existing_atom(nested_association)}
    end
  end
end
