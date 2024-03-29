defmodule JsonApiEctoBuilder.MixProject do
  use Mix.Project

  def project do
    [
      app: :json_api_ecto_builder,
      version: "0.1.1",
      elixir: "~> 1.9",
      description: description(),
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env),
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/test_entities"]
  defp elixirc_paths(_),     do: ["lib"]

  defp description do
    """
    Library for building an ecto query from some JSON API parameters.
    """
  end

  defp package do
    [
      name: "json_api_ecto_builder",
      maintainers: ["Michael Bower", "John Polling"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/MikeyBower93/json_api_ecto_builder"}
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
      {:ecto, "~> 3.3"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
