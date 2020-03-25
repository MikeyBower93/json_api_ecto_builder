defmodule JsonApiEctoBuilderTest.TestEntities.TestEntity do
  use Ecto.Schema

  schema "test_entity" do
    field :x, :string
    field :y, :string

    belongs_to :nested, JsonApiEctoBuilderTest.TestEntities.TestEntity
    belongs_to :second_nested, JsonApiEctoBuilderTest.TestEntities.TestEntity
  end
end
