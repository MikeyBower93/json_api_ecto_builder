defmodule JsonApiEctoBuilder.MixProject do
  use Mix.Project

  def project do
    [
      app: :json_api_ecto_builder,
      version: "0.1.0",
      elixir: "~> 1.9",
      description: description(),
      package: package(),
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  defp description do
    """
    Library for building an ecto query from some JSON API parameters.
    """
  end

  defp package do
    [
      maintainers: ["Michael Bower"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/kkempin/exiban"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.3"}
    ]
  end
end
