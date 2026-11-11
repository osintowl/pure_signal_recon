defmodule PureSignalScout.Tags do
  @moduledoc """
  Tag-based filtering and pivoting for Pure Signal Scout.

  Filter IPs by infrastructure tags to identify specific types
  of infrastructure or threat indicators.

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

  @doc """
  Filter IPs by host or peer tags.

  ## Parameters

    * `client` - A Scout client
    * `ips` - IP address or list of IPs to filter
    * `tags` - Tag or list of tags to filter by
    * `opts` - Optional parameters:
      * `:match_type` - `:host` (IP has tag) or `:peer` (IP's peers have tag)

  ## Returns

    * `{:ok, map}` - Map with IPs matching the tag criteria
    * `{:error, reason}` - Error tuple

  ## Examples

      # Find IPs with malware tag
      {:ok, results} = PureSignalScout.Tags.pivot(client, ips, "malware")

      # Find IPs whose peers are Tor nodes
      {:ok, results} = PureSignalScout.Tags.pivot(client, ips, "tor", match_type: :peer)

      # Multiple tags
      {:ok, results} = PureSignalScout.Tags.pivot(client, ips, ["controller", "bot", "malware"])
  """
  @spec pivot(Client.t(), String.t() | [String.t()], String.t() | [String.t()], keyword()) ::
          {:ok, map()} | {:error, term()}
  def pivot(client, ips, tags, opts \\ []) do
    body =
      %{
        ips: List.wrap(ips),
        tags: List.wrap(tags)
      }
      |> maybe_put(:match_type, opts[:match_type])

    Client.post(client, "/v1/investigate/tag-pivot", body)
  end

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)
end
