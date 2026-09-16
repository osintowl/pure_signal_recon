defmodule PureSignalRecon.MixProject do
  use Mix.Project

  def project do
    [
      app: :pure_signal_recon,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      source_url: "https://github.com/osintowl/pure_signal_recon",
      homepage_url: "https://github.com/osintowl/pure_signal_recon",
      docs: [
        main: "PureSignalRecon",
        extras: ["README.md", "LICENSE"]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:req, "~> 0.5"},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    Elixir client for the Team Cymru Pure Signal Recon API. 
    Query network flow data, malware intelligence, and threat data.
    """
  end

  defp package do
    [
      name: "pure_signal_recon",
      licenses: ["BSD-3-Clause"],
      links: %{
        "GitHub" => "https://github.com/osintowl/pure_signal_recon",
        "Team Cymru" => "https://www.team-cymru.com/post/introducing-pure-signal-recon"
      },
      maintainers: ["Zac Hunsaker"]
    ]
  end
end
