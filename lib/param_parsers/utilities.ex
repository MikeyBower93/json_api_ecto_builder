defmodule JsonApiEctoBuilder.ParamParser.Utilities do
  def maybe_map_to_list(nil), do: []
  def maybe_map_to_list(list), do: Map.to_list(list)

  def maybe_map_string(nil), do: ""
  def maybe_map_string(str), do: str

  def cleanse_association(association) do
    String.replace(association, "-", "_")
  end

  def parse_field_and_associations_from_param(param, base_alias) do
    split_param = param_field_to_parts(param)

    case length(split_param) do
      1 ->
        [field] = split_param
        { field, [Atom.to_string(base_alias)] }
      _ ->
        [field | associations] = split_param
        { field, associations }
    end
  end

  def associations_list_to_named_binding(associations) do
    associations
    |> Enum.reverse
    |> Enum.join("_")
    |> cleanse_association
  end

  def param_field_to_parts(field) do
    field
    |> String.split(".")
    |> Enum.reverse
  end

  def get_sort_direction(field) do
    case String.at(field, 0) do
      "-" ->
        field = String.slice(field, 1..-1)
        { :desc, field }
      _ -> { :asc, field }
    end
  end
end
