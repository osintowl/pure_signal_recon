defmodule PureSignalRecon do
  @moduledoc """
  Elixir client for the Pure Signal Recon API by Team Cymru.

  This library provides a simple interface to interact with the Pure Signal Recon API,
  allowing you to query network flow data, malware reports, and manage jobs and schedules.

  ## Configuration

  You can configure the API key and base URL in your application config:

      config :pure_signal_recon,
        api_key: "your_api_key_here",
        base_url: "https://recon.cymru.com/api"

  Or pass them directly when creating a client:

      iex> client = PureSignalRecon.new(api_key: "your_api_key")

  ## Examples

      # Create a client
      client = PureSignalRecon.new(api_key: "your_api_key")

      # Create a job
      {:ok, job} = PureSignalRecon.Jobs.create(client, %{
        job_name: "Test Job",
        start_date: "2024-01-01T00:00:00Z",
        end_date: "2024-01-02T00:00:00Z",
        queries: [
          %{query_type: "pdns", any_ip_addr: "8.8.8.8"}
        ]
      })

      # Get job details
      {:ok, details} = PureSignalRecon.Jobs.get_details(client, job["id"])

      # List all jobs
      {:ok, jobs} = PureSignalRecon.Jobs.list(client)

      # Get statistics
      {:ok, stats} = PureSignalRecon.Stats.get(client)
  """

  alias PureSignalRecon.Client

  @type client :: Client.t()
  @type api_key :: String.t()
  @type base_url :: String.t()

  @doc """
  Creates a new client with the given options.

  ## Options

    * `:api_key` - Your Pure Signal Recon API key (required)
    * `:base_url` - The base URL for the API (default: "https://recon.cymru.com/api")

  ## Examples

      iex> client = PureSignalRecon.new(api_key: "your_api_key")
      %PureSignalRecon.Client{...}

      iex> client = PureSignalRecon.new(api_key: "your_api_key", base_url: "https://custom.url/api")
      %PureSignalRecon.Client{...}
  """
  @spec new(keyword()) :: client()
  def new(opts \\ []) do
    api_key = Keyword.get(opts, :api_key) || Application.get_env(:pure_signal_recon, :api_key)
    base_url = Keyword.get(opts, :base_url) || Application.get_env(:pure_signal_recon, :base_url) || "https://recon.cymru.com/api"

    unless api_key do
      raise ArgumentError, "API key is required. Pass it as an option or set it in config."
    end

    Client.new(api_key: api_key, base_url: base_url)
  end
end
