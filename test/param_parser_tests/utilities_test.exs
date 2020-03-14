defmodule JsonApiEctoBuilderTest.ParamParserTests.UtilitiesTest do
  use ExUnit.Case

  alias JsonApiEctoBuilder.ParamParser.Utilities

  test "maybe map to list nil" do
    assert Utilities.maybe_map_to_list(nil) == []
  end

  test "maybe map to list not nil" do
    assert Utilities.maybe_map_to_list(%{ "key" => "value" }) == [{"key", "value"}]
  end

  test "maybe map to string nil" do
    assert Utilities.maybe_string(nil) == ""
  end

  test "maybe map to string not nil" do
    assert Utilities.maybe_string("str") == "str"
  end

  #TODO: continue testing here
  test "cleanse association" do
    assert Utilities.cleanse_association("this-is-an-association") == "this_is_an_association"
  end
end
