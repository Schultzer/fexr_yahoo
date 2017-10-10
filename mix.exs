defmodule FexrYahoo.Mixfile do
  use Mix.Project

  @version "0.2.1"

  def project do
    [
      app: :fexr_yahoo,
      version: @version,
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      # Hex
      description: description(),
      package: package(),

      #Docs
      name: "FexrYahoo",
      docs: [source_ref: "v#{@version}",
       main: "FexrYahoo",
       canonical: "http://hexdocs.pm/fexr_yahoo",
       source_url: "https://github.com/schultzer/fexr_yahoo",
       description: "FexrYahoo serve you the latest exchange rates from Yahoo exchange in a simple developer friendly map."]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {FexrYahoo.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:httpoison, "~> 0.12"},
      {:poison, "~> 3.1"},
      {:con_cache, "~> 0.12"}
    ]
  end

  defp description do
  """
  FexrYahoo serve you the latest exchange rates from Yahoo exchange in a simple developer friendly map.
  """
  end

  defp package do
    [name: :fexr_yahoo,
     maintainers: ["Benjamin Schultzer"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/schultzer/fexr_yahoo",
              "Docs" => "https://hexdocs.pm/fexr_yahoo"},
     files: ~w(lib) ++
            ~w(mix.exs README.md LICENSE mix.exs)]
  end

end
