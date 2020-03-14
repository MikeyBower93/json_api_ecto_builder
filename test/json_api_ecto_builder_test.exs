defmodule JsonApiEctoBuilderTest do
  use ExUnit.Case
  doctest JsonApiEctoBuilder

  alias JsonApiEctoBuilder.ParamParser.Include

  test "greets the world" do
    # assert JsonApiEctoBuilder.hello() == :world
    "space_center.country"
    |> String.split(".")
    |> Include.parse_include_to_param_from_param_split([])
    |> IO.puts
  end
end
