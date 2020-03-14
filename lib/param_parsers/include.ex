defmodule JsonApiEctoBuilder.ParamParser.Include do
  alias JsonApiEctoBuilder.ParamParser.Utilities

  def parse(params) do
    Map.get(params, "include")
    |> Utilities.maybe_map_string
    |> String.split(",")
    |> Enum.reduce([], fn param, preload_list ->
        param = String.replace(param, "-", "_")
        parse_include_to_param(preload_list, param)
        # Utilities.cleanse_association(param)
        # |> String.split(".")
        # |> parse_include_to_param_from_param_split(preload_list)
      end)
  end

  defp parse_include_to_param(list, param) do
    case String.contains?(param, ".") do
      true ->
        [first | rest] =
          param
          |> String.split(".")

        rest = Enum.join(rest, ".")

        new_value = String.to_atom(first)

        case Keyword.has_key?(list, new_value) do
          false ->
            Keyword.put(list, new_value, parse_include_to_param([], rest))
          true ->
            existing_value = Keyword.get(list, new_value)
            Keyword.put(list, new_value, parse_include_to_param(existing_value, rest))

        end
      false ->
        new_value = String.to_atom(param)
        case Keyword.has_key?(list, new_value) do
          false ->
            list ++ [new_value]
          true ->
            list
        end
    end
  end
  # defp parse_include_to_param_from_param_split([param], list) do
  #   new_value = String.to_atom(param)

  #   case Keyword.has_key?(list, new_value) do
  #     false ->
  #       list ++ [new_value]
  #     true ->
  #       list
  #   end
  # end

  # defp parse_include_to_param_from_param_split([param | rest], list) do
  #   new_value = String.to_atom(param)

  #   case Keyword.has_key?(list, new_value) do
  #     false ->
  #       Keyword.put(list, new_value, parse_include_to_param_from_param_split([], rest))
  #     true ->
  #       existing_value = Keyword.get(list, new_value)
  #       Keyword.put(list, new_value, parse_include_to_param_from_param_split(existing_value, rest))
  #   end
  # end
end
