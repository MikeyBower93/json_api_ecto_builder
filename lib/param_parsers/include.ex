defmodule JsonApiEctoBuilder.ParamParser.Include do
  alias JsonApiEctoBuilder.ParamParser.Utilities

  def parse(params) do
    Map.get(params, "include")
    |> Utilities.maybe_map_string
    |> String.split(",")
    |> Enum.reduce([], fn param, preload_list ->
        Utilities.cleanse_association(param)
        |> String.split(".")
        |> parse_include_to_param_from_param_split(preload_list)
      end)
  end

  def parse_include_to_param_from_param_split([param], list) do
    new_value = String.to_atom(param)

    case Keyword.has_key?(list, new_value) do
      false ->
        list ++ [new_value]
      true ->
        list
    end
  end

  def parse_include_to_param_from_param_split([param | rest], list) do
    new_value = String.to_atom(param)

    case Keyword.has_key?(list, new_value) do
      false ->
        Keyword.put(list, new_value, parse_include_to_param_from_param_split(rest, []))
      true ->
        existing_value = Keyword.get(list, new_value)
        Keyword.put(list, new_value, parse_include_to_param_from_param_split(rest, existing_value))
    end
  end
end
