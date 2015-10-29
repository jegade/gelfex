defmodule Gelfex.Mixfile do
  use Mix.Project

  def project do
    [app: :gelfex,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     docs: [extras: ["README.md"]],
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      registered: [Gelfex, Gelfex.Supervisor],
      mod: {Gelfex, []},
      applications: [:logger]
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:poison, "~> 1.0"},
      {:connection, "~> 1.0"},

      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.10", only: :dev},
    ]
  end

  defp description do
    """
    Elixir client for logging GELF messages to Graylog.
    """
  end

  defp package do
    [maintainers: ["Don Pinkster"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/donpinkster/gelfex"}]
  end
end
