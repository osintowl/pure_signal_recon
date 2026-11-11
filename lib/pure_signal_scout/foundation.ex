defmodule PureSignalScout.Foundation do
  @moduledoc """
  Scout Foundational API for bulk IP triage.

  Foundational is the cheapest Team Cymru lookup - 10 IPs per query from
  a 15k/month pool. Returns rating, insights, tags, ASN, country, and
  top-5 samples of pDNS, ports, and certs for each IP.

  **Important**: This endpoint is at `scout.cymru.com`, NOT `command.cymru.com`.
  It requires the Recon key, not the Command key.

  ## Usage

      # Create a client pointing to scout.cymru.com with the Recon key
      client = PureSignalScout.Client.new(
        api_key: recon_key,
        base_url: "https://scout.cymru.com/api"
      )

      # Query up to 10 IPs at once
      {:ok, results} = PureSignalScout.Foundation.get(client, ["8.8.8.8", "1.1.1.1"])

  ## Response fields per IP

    * `overall_rating` - Risk rating (note: `no_rating` means no signal, not clean)
    * `insights` - AI-generated insights (unlimited pool)
    * `tags` - Behavioral/infrastructure tags
    * `asn` / `as_name` - AS information
    * `country` - Country code
    * `pdns` - Top 5 passive DNS records
    * `ports` - Top 5 open ports
    * `certs` - Top 5 certificates

  ## Limits

    * Max 10 IPs per request
    * Invalid IPs will 400 the entire batch - validate first
    * Lists (pdns, ports, certs) capped at 5 items each
  """

  alias PureSignalScout.Client

  @max_ips 10

  @doc """
  Get foundational data for up to 10 IPs.

  ## Parameters

    * `client` - A Scout client configured for scout.cymru.com with Recon key
    * `ips` - List of IP addresses (max 10)

  ## Returns

    * `{:ok, list}` - List of IP foundation data
    * `{:error, :too_many_ips}` - More than 10 IPs provided
    * `{:error, reason}` - Other errors

  ## Examples

      {:ok, results} = PureSignalScout.Foundation.get(client, ["8.8.8.8"])
      {:ok, results} = PureSignalScout.Foundation.get(client, ["8.8.8.8", "1.1.1.1"])
  """
  @spec get(Client.t(), list(String.t())) :: {:ok, list(map())} | {:error, term()}
  def get(_client, ips) when length(ips) > @max_ips do
    {:error, :too_many_ips}
  end

  def get(client, ips) when is_list(ips) do
    ips_param = Enum.join(ips, ",")
    Client.get(client, "/scout/ip/foundation", params: [ips: ips_param])
  end

  def get(client, ip) when is_binary(ip) do
    get(client, [ip])
  end

  @doc """
  Get foundational data for IPs in chunks of 10.

  Automatically splits larger lists and combines results.

  ## Parameters

    * `client` - A Scout client configured for scout.cymru.com with Recon key
    * `ips` - List of IP addresses (any size)

  ## Returns

    * `{:ok, list}` - Combined list of IP foundation data
    * `{:error, reason}` - First error encountered
  """
  @spec get_chunked(Client.t(), list(String.t())) :: {:ok, list(map())} | {:error, term()}
  def get_chunked(client, ips) do
    ips
    |> Enum.chunk_every(@max_ips)
    |> Enum.reduce_while({:ok, []}, fn chunk, {:ok, acc} ->
      case get(client, chunk) do
        {:ok, results} -> {:cont, {:ok, acc ++ results}}
        {:error, _} = error -> {:halt, error}
      end
    end)
  end

  @doc """
  Extract certificates from foundational response.

  Returns a flat list of all certificates across all IPs in the response.
  """
  @spec extract_certs(list(map())) :: list(map())
  def extract_certs(results) when is_list(results) do
    Enum.flat_map(results, fn result ->
      certs = Map.get(result, "certs", []) || []
      ip = Map.get(result, "ip")

      Enum.map(certs, fn cert ->
        Map.put(cert, "ip", ip)
      end)
    end)
  end
end
