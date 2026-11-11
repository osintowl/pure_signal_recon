defmodule PureSignalScout.Advanced do
  @moduledoc """
  Advanced investigation operations for Pure Signal Scout.

  Includes fan-in analysis, IP range searches, and perimeter sweeps.
  """

  alias PureSignalScout.Client

  @doc """
  Find IPs with many sources connecting on a specific port (fan-in analysis).

  Useful for identifying C2 servers, sinkholes, or popular services.

  ## Parameters

    * `client` - A Scout client
    * `port` - Port number to analyze
    * `opts` - Optional parameters:
      * `:min_sources` - Minimum number of source IPs
      * `:limit` - Maximum results

  ## Returns

    * `{:ok, map}` - Map with IPs receiving connections from many sources
    * `{:error, reason}` - Error tuple

  ## Examples

      # Find IPs with many connections on port 443
      {:ok, results} = PureSignalScout.Advanced.fan_in(client, 443,
        min_sources: 100,
        limit: 50
      )
  """
  @spec fan_in(Client.t(), integer(), keyword()) :: {:ok, map()} | {:error, term()}
  def fan_in(client, port, opts \\ []) do
    body =
      %{port: port}
      |> maybe_put(:min_sources, opts[:min_sources])
      |> maybe_put(:limit, opts[:limit])

    Client.post(client, "/v1/investigate/fan-in", body)
  end

  @doc """
  Search for IPs in a range within a time window.

  ## Parameters

    * `client` - A Scout client
    * `ip_range` - CIDR notation (e.g., "192.168.1.0/24")
    * `opts` - Optional parameters:
      * `:start_time` - Start of time window
      * `:end_time` - End of time window
      * `:limit` - Maximum results

  ## Returns

    * `{:ok, map}` - Map with IPs found in the range during the time window
    * `{:error, reason}` - Error tuple

  ## Examples

      {:ok, results} = PureSignalScout.Advanced.search_ips(client, "192.168.0.0/16",
        start_time: "2024-01-01T00:00:00Z",
        end_time: "2024-01-31T23:59:59Z"
      )
  """
  @spec search_ips(Client.t(), String.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def search_ips(client, ip_range, opts \\ []) do
    body =
      %{ip_range: ip_range}
      |> maybe_put(:start_time, opts[:start_time])
      |> maybe_put(:end_time, opts[:end_time])
      |> maybe_put(:limit, opts[:limit])

    Client.post(client, "/v1/investigate/search-ips", body)
  end

  @doc """
  Perimeter sweep - find outbound traffic to malicious infrastructure.

  Scans specified IP ranges for OUTBOUND traffic to malicious-tagged
  infrastructure like C2, botnets, malware, etc.

  ## Parameters

    * `client` - A Scout client
    * `ip_ranges` - List of CIDR ranges to check
    * `opts` - Optional parameters:
      * `:tags` - Tags to look for (default: controller, bot, malware, ost, orb, socks, tor, open-dir, res-proxy)
      * `:start_time` - Start of time window
      * `:end_time` - End of time window

  ## Returns

    * `{:ok, map}` - Map with outbound connections to malicious infrastructure
    * `{:error, reason}` - Error tuple

  ## Examples

      # Check corporate ranges for malicious outbound
      {:ok, results} = PureSignalScout.Advanced.perimeter_sweep(client,
        ["10.0.0.0/8", "172.16.0.0/12"],
        start_time: "2024-01-01T00:00:00Z",
        end_time: "2024-01-02T00:00:00Z"
      )

      # Custom tags
      {:ok, results} = PureSignalScout.Advanced.perimeter_sweep(client,
        ["192.168.0.0/16"],
        tags: ["tor", "socks", "cobaltstrike"]
      )
  """
  @spec perimeter_sweep(Client.t(), String.t() | [String.t()], keyword()) ::
          {:ok, map()} | {:error, term()}
  def perimeter_sweep(client, ip_ranges, opts \\ []) do
    default_tags = [
      "controller",
      "bot",
      "malware",
      "ost",
      "orb",
      "socks",
      "tor",
      "open-dir",
      "res-proxy"
    ]

    body =
      %{
        ip_ranges: List.wrap(ip_ranges),
        tags: opts[:tags] || default_tags
      }
      |> maybe_put(:start_time, opts[:start_time])
      |> maybe_put(:end_time, opts[:end_time])

    Client.post(client, "/v1/investigate/perimeter-sweep", body)
  end

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)
end
