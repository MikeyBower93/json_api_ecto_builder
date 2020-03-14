defmodule JsonApiEctoBuilder.ParamParser.Join do
  alias JsonApiEctoBuilder.ParamParser.Utilities

  def parse(params) do
    combined_params = get_filter_and_sort_list(params)

    join_set =
      combined_params
      |> Enum.reduce(MapSet.new, fn field, map_set ->
          field_parts = Utilities.param_field_to_parts(field)
          if length(field_parts) > 1 do
            [_ | associations] = field_parts
            associations
            |> Enum.reverse
            |> build_join_map_set(map_set, nil)
          else
            map_set
          end
        end)

    join_set
    |> Enum.sort
    |> Enum.map(&Utilities.cleanse_association/1)
    |> Enum.map(&String.to_atom/1)
  end

  defp get_filter_and_sort_list(params) do
    filter_params =
      params
      |> Map.get("filter")
      |> Utilities.maybe_map_to_list
      |> Enum.map(fn {field, _value} ->
          field
        end)

    sort_params =
      params
      |> Map.get("sort")
      |> Utilities.maybe_map_string
      |> String.split(",")
      |> Enum.map(fn field ->
          { _direction, field } = Utilities.get_sort_direction(field)
          field
        end)

    Enum.concat(filter_params, sort_params)
  end

  defp build_join_map_set([association], set, nil) do
    MapSet.put(set, association)
  end

  defp build_join_map_set([association], set, accumulator) do
    MapSet.put(set, "#{accumulator}_#{association}")
  end

  defp build_join_map_set([association | rest], set, nil) do
    set = MapSet.put(set, association)
    build_join_map_set(rest, set, association)
  end

  defp build_join_map_set([association | rest], set, accumulator) do
    accumulator = "#{accumulator}_#{association}"
    set = MapSet.put(set, accumulator)
    build_join_map_set(rest, set, accumulator)
  end
end
