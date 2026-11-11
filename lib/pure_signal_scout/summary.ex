defmodule PureSignalScout.Summary do
  @moduledoc """
  IP summary and enrichment operations for Pure Signal Scout.

  Provides IP enrichment with risk scores, infrastructure tags,
  ASN information, and geolocation data.

  ## Notable Tags

  Adversary indicators:
  - `risknet` - Known risky network
  - `socks` - SOCKS proxy
  - `tor` - Tor exit node
  - `cobaltstrike` - Cobalt Strike beacon
  - `controller` - C2 controller
  - `bot` - Bot/botnet
  - `malware` - Known malware
  - `ost` - Offensive security tool
  - `orb` - Operational relay box

  Dual-use infrastructure:
  - `astrill-vpn` - Astrill VPN
  - `anydesk` - AnyDesk remote access
  - `warp-vpn` - Cloudflare WARP VPN
  - `pia` - Private Internet Access VPN
  - `1-vpn` - 1VPN service
  """

  alias PureSignalScout.Client

  @max_bulk_ips 20

  @doc """
  Get IP summary with risk scores and infrastructure tags.

  ## Parameters

    * `client` - A Scout client
    * `ip` - IP address to lookup (e.g., "8.8.8.8")

  ## Returns

    * `{:ok, map}` - Map with IP summary including risk, tags, ASN, geolocation
    * `{:error, reason}` - Error tuple

  ## Examples

      {:ok, summary} = PureSignalScout.Summary.get(client, "8.8.8.8")
  """
  @spec get(Client.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def get(client, ip) when is_binary(ip) do
    Client.post(client, "/v1/investigate/summary", %{ip: ip})
  end

  @doc """
  Bulk IP enrichment with automatic chunking.

  Requests are automatically chunked at 20 IPs to avoid empty results
  from the API.

  ## Parameters

    * `client` - A Scout client
    * `ips` - List of IP addresses

  ## Returns

    * `{:ok, list}` - List of enrichment results for all IPs
    * `{:error, reason}` - Error tuple

  ## Examples

      {:ok, results} = PureSignalScout.Summary.enrich_all(client, ["8.8.8.8", "1.1.1.1"])
  """
  @spec enrich_all(Client.t(), [String.t()]) :: {:ok, list()} | {:error, term()}
  def enrich_all(client, ips) when is_list(ips) do
    ips
    |> Enum.chunk_every(@max_bulk_ips)
    |> Enum.reduce_while({:ok, []}, fn chunk, {:ok, acc} ->
      case Client.post(client, "/v1/investigate/enrich-all", %{ips: chunk}) do
        {:ok, results} when is_list(results) -> {:cont, {:ok, acc ++ results}}
        {:ok, result} when is_map(result) -> {:cont, {:ok, acc ++ [result]}}
        {:error, _} = error -> {:halt, error}
      end
    end)
  end
end
