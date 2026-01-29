defmodule Rpi4MouseUi.MixProject do
  use Mix.Project

  def project do
    [
      app: :rpi4_mouse_ui,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Rpi4MouseUi.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.8.0"},
      {:phoenix_html, "~> 4.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 1.1.0"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.8.0"},
      {:esbuild, "~> 0.7", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.4.0", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 1.1"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 1.0"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "assets.setup", "assets.build"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind default", "esbuild default"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"],
      "ui.compile": [&ui_compile/1]
    ]
  end

  defp ui_compile(_args) do
    Mix.shell().info("""

    mix ui.compile start...
    MIX_TARGET: #{System.get_env("MIX_TARGET") || Mix.target()}
    MIX_ENV:    #{System.get_env("MIX_ENV") || Mix.env()}
    """)

    if Mix.target() == :host do
      {_, 0} = System.cmd("mix", ["assets.setup"], into: IO.stream(:stdio, :line))
      {_, 0} = System.cmd("mix", ["assets.build"], into: IO.stream(:stdio, :line))
    else
      {_, 0} = System.cmd("mix", ["deps.get"], into: IO.stream(:stdio, :line))
      {_, 0} = System.cmd("mix", ["deps.compile"], into: IO.stream(:stdio, :line))
      {_, 0} = System.cmd("mix", ["assets.setup"], into: IO.stream(:stdio, :line))
      {_, 0} = System.cmd("mix", ["assets.deploy"], into: IO.stream(:stdio, :line))
    end
  end
end
