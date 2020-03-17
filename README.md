# JsonApiEctoBuilder

## Description
The purpose of this package is to build up an ecto query from some JSON API query parameters, 99.99% of the time when we create a JSON API endpoint we want to do the same sets of operations, therefore it is wasted effort and wasted code to keep writing the same thing over and over again. 

## Installation
The package can be installed by adding `json_api_ecto_builder` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:json_api_ecto_builder, git: "https://github.com/MikeyBower93/json_api_ecto_builder.git"}
  ]
end
```
## Getting Started

Getting started with this library is easy to do however there are a few standards that you must follow for it to work. 

**Note** - this guide presumes you have setup your Phoenix endpoints, database, and  schemas.

### Creating an entity module

All we need to do to use this library is to create an entity module (you can put this in the controller module, however for simlicity I store it in another module), which should look like the following:

```elixir
defmodule ElixirJsonApi.JsonApiEctoBuilders.Rocket do
  import JsonApiEctoBuilder
end 
```
I have created the module, in this case the schema/entity is a rocket. I have also imported the `JsonApiEctoBuilder` library which will expose the required function for you to builder a request. 

### Calling the builder
To call the builder you will need to create a function in your new module, your module should end up looking like:

```elixir
defmodule ElixirJsonApi.JsonApiEctoBuilders.Rocket do
  alias ElixirJsonApi.Rocket

  import Ecto.Query
  import JsonApiEctoBuilder

  def build(params) do
    build_query(base_query(), base_type(), base_alias(), params, &apply_join/2)
  end

  def base_query(), do: from r in Rocket, as: :rocket

  def base_type(), do: Rocket

  def base_alias(), do: :rocket

  def apply_join(:space_center, query) do
    query
    |> join(:inner, [rocket: r], assoc(r, :space_center), as: :space_center)
  end

  def apply_join(:space_center_country, query) do
    query
    |> join(:inner, [space_center: sc], assoc(sc, :country), as: :space_center_country)
  end

  def apply_join(:astronauts, query) do
    query
    |> join(:inner, [rocket: r], assoc(r, :astronauts), as: :astronauts)
  end
end

```

Some of the parameters, functions in this module I will describe shortly, the main thing here is the `build` function accepts params (these are phoenix query parameters), we then call `build_query` which is a call to the internal library function. 

5 parameters are required to execute the build which are as follows:

#### Base Query
This is the base query you want the builder to append to, this can be useful if you want to do any pre-processing on the query such as security safe guards where you might want to limit the results by something on the user token. Please note, if you need to do any joins keep them in the same format as descriped in the apply join paramter section. 

In this base query at a minmum you will need to select from the base entity, in this case the rocket, and give an alias which is usually just the type name, so in this circumstance `:rocket`. 

#### Base Type
This is the base type of the main entity, this is so we can run introspection to find out things like the primary key on the type etc, in this circumstance it is simply `Rocket`. 

#### Base Alias
This is the name of the alias you gave the base query, in this case it is `:rocket`.

#### Params
This is the raw phoenix parameters you are passed, this includes the filters, sorts, includes etc.

#### Join Appliers
This is a callback function that executes when the calling code sees that it needs to apply a join, unfortuantly at this point we cannot build the joins directly in the library as at runtime you cannot create named aliases from a variable, it needs to be a compile time atom. Some work might be done in the future to make this generate using macros, however for not is simple enough to add. 

In the example I have given I have passed in a function declared in the module I created, and it patttern matches to see which join it needs to apply. The way this works is every if it sees a nested association in your filter or sort such as `rocket->space_center->country` it will break down that association and apply a join for each nesting and create an alias of the association accumulation. For example in the `rocket->space_center->country` example, it will break this down into the following:

1. rocket
2. rocket_space_center
3. rocket_space_center_country

It will run these in order if it requires them, and will only request them once, so in the example module, you can see that when it sees `space_center` it pulls out the `rocket` named binding as it knows thats what it is associated to, and then when it sees `space_center_country`, it knows that its the `country` associated to the `space_center` so it pulls out the `space_center` binding and joins to that, because of the way the library applies this you can be assured that if it requests `space_center_country` it will have already requested `space_center` to be joined. 

### Reponse
After the builder is done, it returns the query with these filters, sorts, preloads added. You can adapt it after this but its recommend you do it in the pre query as there are sub queries built into this which might not give you any desired results by doing after the query is built. 

## JSON API Parameter Format

### Sorting
The format of the sort in the quer paramters should be `sort=field,-nested1.nested2.field` with the `-` meaning descending. 

### Including
Includes should follow the format of `entity,entity2.nested_entity`

### Filters
Filters should be in the following format `filter[field]=value` for a simple equals filter on a property on the entity, or `filter[association.field]=value` if you want to filter a nested property. 

If you want to a different type of filter that isn't an equals you format the query as the following: `filter[field][operator]=value` using one of the following operators:
- EQ - equal
- NEQ - not equal
- LK - like
- LT - less than
- LTE - less than or equal to
- GT - greater than
- GTE - greater than or equal to 

## Developer Notes

## Final Notes/Other Libraries


As described in the guide if you need to do any security checks you do this as a pre request, if this requires any joins please follow the join named alias formats defined in join appliers section. 

This library doesn't currently support grouping and conditional types such as or/and etc, if you need to implement something like a search I recommend you pass something back like `filter[my_search]=value` and that you pick that out of the query parameters, add the `my_search` you want to define to the pre-request, if doing this you must removed the `my_search` filter from the query parameters. 

This library does not doing pagination or phoenix view rendering, for this I recommend using
- https://github.com/drewolson/scrivener (pagination)
- https://github.com/vt-elixir/ja_serializer (phoenix view rendering)

These are already good and well developed libraries so there is no need for me to rewrite them, I could have included scrivener in the library however this way you can use another library if you want, and it also would mean that I would be calling the `Repo.paginate` function which would mean you couldn't extend the resulting query. 
 