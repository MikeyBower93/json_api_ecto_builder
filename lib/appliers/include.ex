defmodule JsonApiEctoBuilder.Applier.Include do
  import Ecto.Query

  alias JsonApiEctoBuilder.ParamParser.Include

  def apply(query, params) do
    preloads = Include.parse(params)

    case length(preloads) do
      0 -> query
      _ ->preload(query, ^preloads)
    end
  end
end
