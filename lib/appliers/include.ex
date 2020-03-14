defmodule JsonApiEctoBuilder.Applier.Include do
  import Ecto.Query

  alias JsonApiEctoBuilder.ParamParser.Include

  def apply(query, params) do
    preloads = Include.parse(params)

    query
    |> preload(^preloads)
  end
end
