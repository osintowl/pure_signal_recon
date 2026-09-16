defmodule PureSignalRecon.MixProject do
  use Mix.Project

  def project do
    [
      app: :pure_signal_recon,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      source_url: "https://github.com/hunsazk/pure_signal_recon"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:req, "~> 0.5"}
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
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/hunsazk/pure_signal_recon",
        "Team Cymru" => "https://www.team-cymru.com/post/introducing-pure-signal-recon"
      }
    ]
  end
end
