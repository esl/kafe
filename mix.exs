defmodule Kafe.Mixfile do
  use Mix.Project

  def project do
    [
      app: :kafe,
      version: "2.1.8",
      elixir: "~> 1.2",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps,
      aliases: aliases
    ]
  end

  def application do
    [
       applications: [:syntax_tools, :compiler, :poolgirl, :goldrush, :lager, :bucs, :doteki, :metrics],
       env: [],
       mod: {:kafe_app, []}
    ]
  end

  defp deps do
    [
      {:lager, "~> 3.2.0"},
      {:bucs, "~> 1.0.3"},
      {:doteki, "~> 1.0.3"},
      {:poolgirl, "~> 1.1.1"},
      {:bristow, "~> 0.2.1"},
      {:metrics, "~> 2.2.0"}    
    ]
  end

  defp aliases do
    [compile: &compile_with_hooks/1]
  end

  defp compile_with_hooks(args) do
    pre_compile_hooks()
    result = Mix.Task.run("compile", args)
    post_compile_hooks()
    result
  end

  defp pre_compile_hooks() do
    run_hook_cmd [
    ]
  end

  defp post_compile_hooks() do
    run_hook_cmd [
    ]
  end

  defp run_hook_cmd(commands) do
    {_, os} = :os.type
    for command <- commands, do: (fn
      ({regex, cmd}) ->
         if Regex.match?(Regex.compile!(regex), Atom.to_string(os)) do
           Mix.Shell.cmd cmd, [], fn(x) -> Mix.Shell.IO.info(String.strip(x)) end
         end
      (cmd) ->
        Mix.Shell.cmd cmd, [], fn(x) -> Mix.Shell.IO.info(String.strip(x)) end
      end).(command)
  end    
end