defmodule Kafe.Mixfile do
  use Mix.Project

  def project do
    [
      app: :kafe,
      version: "1.5.0",
      elixir: "~> 1.2",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps
    ]
  end

  def application do
    [
       applications: [:syntax_tools, :compiler, :poolgirl, :goldrush, :lager],
       env: [],
       mod: {:kafe_app, []}
    ]
  end

  defp deps do
    [
      {:lager, "~> 3.2.0"},
      {:bucs, "~> 0.1.0"},
      {:doteki, "~> 0.1.1"},
      {:poolgirl, "~> 0.1.0"},
      {:bristow, "~> 0.1.0"}    
    ]
  end
end