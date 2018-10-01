defmodule Tiled.Mixfile do
  use Mix.Project

  @name Tiled
  @version "0.1.0"
  @description "Tiled Map Editor parser"

  @repo_url "https://github.com/seivan/#{@name}"

  # Run "mix help deps" to learn about dependencies.

  @deps [
    {:poison, "~> 3.1"},
  ]

  @dev_deps [
    {:stream_data, " >= 0.1.0"},
  ]

  @no_runtime_deps [
    {:dialyxir, "~> 0.5.1"},
    {:ex_doc, "~> 0.15"},
    {:mix_test_watch, "~> 0.3.3"},
    {:fs, github: "synrc/fs", manager: :rebar, override: true},

  ]

  @package [
    maintainers: ["Seivan Heidari"],
    licenses: ["MIT"],
    links: %{"GitHub" => @repo_url}
  ]

  defp deps do
    dev = [only: [:dev, :test]]
    no_runtime = dev ++ [runtime: false]

    update_options = fn dev_options ->
      fn
        {name, version, options} when is_list(options) -> {name, version, dev_options |> Keyword.merge(options)}
        {name, options} when is_list(options) -> {name, dev_options |> Keyword.merge(options)}
        {name, version} when is_binary(version) -> {name, version, dev_options}
      end
    end


    @deps
    ++ (@dev_deps |> Enum.map(update_options.(dev)))
    ++ (@no_runtime_deps |> Enum.map(update_options.(no_runtime)))
  end

  def project do
    in_production = Mix.env() == :prod

    [
      app: @name |> Macro.underscore() |> String.to_atom(),
      version: @version,
      elixir: "~> 1.6",
      start_permanent: in_production,
      build_embedded: true,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env),


      # Hex
      package: @package,
      description: @description,

      # Docs
      name: @name,
      docs: [
        main: @name,
        source_ref: "#{@version}",
        source_url: @repo_url,
        homepage_url: @repo_url,
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [extra_applications: [:logger]]
  end

  defp elixirc_paths(_ \\ nil)
  defp elixirc_paths(:test), do: elixirc_paths() ++ ["test/helpers"]
  defp elixirc_paths(_), do: ["lib"]
end
