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

  test "cleanse association" do
    assert Utilities.cleanse_association("this-is-an-association") == "this_is_an_association"
  end

  test "param field to parts reverses fields" do
    assert Utilities.param_field_to_parts("entity.entity2.field") == ["field", "entity2", "entity"]
  end

  test "Parse fields and associations flat" do
    assert Utilities.parse_field_and_associations_from_param("field", :base_alias) == {"field", ["base_alias"]}
  end

  test "Parse fields and associations nested" do
    assert Utilities.parse_field_and_associations_from_param("entity.entity2.field", :base_alias) == {"field", ["entity2", "entity"]}
  end

  test "Associations to named binding" do
    #Tests that when an associations list has been parsed (probably using parse_field_and_associations_from_param)
    #to have the fields reversed, that this can get merged into the correct order for a named binding to apply something
    #to a join.
    assert Utilities.associations_list_to_named_binding(["entity2", "entity"]) == "entity_entity2"
  end

  test "Field ascending" do
    assert Utilities.get_sort_direction("field") == {:asc, "field"}
  end

  test "Field desecending" do
    assert Utilities.get_sort_direction("-field") == {:desc, "field"}
  end

  test "Maybe enumerable list" do
    assert = Utilities.maybe_enumerable([1, 2]) == [1, 2]
  end

  test "Maybe enumerable map" do
    assert = Utilities.maybe_enumerable(%{ "a" => 1, "b" => 2 }) == %{ "a" => 1, "b" => 2 }
  end

  test "Maybe enumerable string" do
    assert = Utilities.maybe_enumerable("a") == ["a"]
  end
end
