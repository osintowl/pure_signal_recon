defmodule PureSignalRecon.MixProject do
  use Mix.Project

  def project do
    [
      app: :pure_signal_recon,
      version: "0.3.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      source_url: "https://github.com/osintowl/pure_signal_recon",
      homepage_url: "https://github.com/osintowl/pure_signal_recon",
      docs: [
        main: "readme",
        extras: ["README.md", "LICENSE"],
        groups_for_modules: [
          Recon: [
            PureSignalRecon,
            PureSignalRecon.Client,
            PureSignalRecon.Jobs,
            PureSignalRecon.Schedules,
            PureSignalRecon.Results,
            PureSignalRecon.Malware,
            PureSignalRecon.Maps,
            PureSignalRecon.TaggedIPs,
            PureSignalRecon.Tags,
            PureSignalRecon.Stats,
            PureSignalRecon.Estimate,
            PureSignalRecon.Pdns,
            PureSignalRecon.Certs,
            PureSignalRecon.OpenDir,
            PureSignalRecon.Host,
            PureSignalRecon.Search
          ],
          Scout: [
            PureSignalScout,
            PureSignalScout.Client,
            PureSignalScout.Summary,
            PureSignalScout.Comms,
            PureSignalScout.Pdns,
            PureSignalScout.Risk,
            PureSignalScout.Tags,
            PureSignalScout.Hunt,
            PureSignalScout.Advanced
          ]
        ]
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
      {:req, "~> 0.5 or ~> 0.6 or ~> 0.7"},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    Elixir client for the Team Cymru Pure Signal platform (Recon + Scout).
    Query network flows, malware intelligence, IP enrichment, threat tags, and more.
    """
  end

  defp package do
    [
      name: "pure_signal_recon",
      licenses: ["BSD-3-Clause"],
      links: %{
        "GitHub" => "https://github.com/osintowl/pure_signal_recon",
        "Pure Signal Recon" => "https://www.team-cymru.com/post/introducing-pure-signal-recon",
        "Pure Signal Scout" => "https://www.team-cymru.com/pure-signal-scout"
      },
      maintainers: ["Zac Hunsaker"]
    ]
  end
end
