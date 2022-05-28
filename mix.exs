defmodule SecEdgar.MixProject do
  use Mix.Project

  @version "0.0.1"
  @url "https://github.com/david-christensen/sec_edgar"

  def project do
    [
      app: :sec_edgar,
      version: @version,
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      description: "An elixir client library for the data.sec.gov API.",
      deps: deps(),
      package: package()
    ]
  end

  defp package do
    %{
      licenses: ["MIT"],
      maintainers: ["David Christensen"],
      links: %{"GitHub" => @url}
    }
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:finch, "~> 0.3.0"},
      {:jason, "~> 1.2"},
      {:mox, "~> 1.0", only: :test}
    ]
  end
end
