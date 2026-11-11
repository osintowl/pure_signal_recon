defmodule PureSignalScout do
  @moduledoc """
  Elixir client for the Pure Signal Scout API by Team Cymru.

  Scout provides IP/domain enrichment, threat intelligence, netflow analysis,
  risk scoring, and infrastructure hunting capabilities.

  ## Configuration

  You can configure the API key and base URL in your application config:

      config :pure_signal_recon,
        scout_api_key: "your_api_key_here",
        scout_base_url: "https://command.cymru.com/api"

  Or pass them directly when creating a client:

      iex> client = PureSignalScout.new(api_key: "your_api_key")

  ## Examples

      # Create a client
      client = PureSignalScout.new(api_key: "your_api_key")

      # Get IP summary with risk scores and tags
      {:ok, summary} = PureSignalScout.Summary.get(client, "8.8.8.8")

      # Get communication peers (netflow)
      {:ok, comms} = PureSignalScout.Comms.get(client, "192.168.1.1",
        start_time: "2024-01-01T00:00:00Z",
        end_time: "2024-01-02T00:00:00Z"
      )

      # Get passive DNS records
      {:ok, pdns} = PureSignalScout.Pdns.get(client, "8.8.8.8")

      # Bulk risk scores
      {:ok, risks} = PureSignalScout.Risk.get(client, ["8.8.8.8", "1.1.1.1"])

      # Hunt by banner pattern
      {:ok, results} = PureSignalScout.Hunt.banner(client, "nginx")

      # Hunt by certificate CN
      {:ok, results} = PureSignalScout.Hunt.cert(client, "*.google.com")
  """

  alias PureSignalScout.Client

  @type client :: Client.t()
  @type api_key :: String.t()
  @type base_url :: String.t()

  @default_base_url "https://command.cymru.com/api"

  @doc """
  Creates a new Scout client with the given options.

  ## Options

    * `:api_key` - Your Pure Signal Scout API key (required)
    * `:base_url` - The base URL for the API (default: "https://command.cymru.com/api")

  ## Examples

      iex> client = PureSignalScout.new(api_key: "your_api_key")
      %PureSignalScout.Client{...}

      iex> client = PureSignalScout.new(api_key: "your_api_key", base_url: "https://custom.url/api")
      %PureSignalScout.Client{...}
  """
  @spec new(keyword()) :: client()
  def new(opts \\ []) do
    api_key = Keyword.get(opts, :api_key) || Application.get_env(:pure_signal_recon, :scout_api_key)

    base_url =
      Keyword.get(opts, :base_url) ||
        Application.get_env(:pure_signal_recon, :scout_base_url) ||
        @default_base_url

    unless api_key do
      raise ArgumentError, "API key is required. Pass it as an option or set it in config."
    end

    Client.new(api_key: api_key, base_url: base_url)
  end
end
