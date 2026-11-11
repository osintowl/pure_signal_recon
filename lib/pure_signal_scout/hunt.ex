defmodule PureSignalScout.Hunt do
  @moduledoc """
  Infrastructure hunting operations for Pure Signal Scout.

  Hunt for infrastructure by banner patterns, certificate attributes,
  or other fingerprints.
  """

  alias PureSignalScout.Client

  @doc """
  Hunt for IPs by banner pattern.

  ## Parameters

    * `client` - A Scout client
    * `pattern` - Banner pattern to search for (regex supported)
    * `opts` - Optional parameters:
      * `:ips` - List of IPs to search within
      * `:limit` - Maximum results

  ## Returns

    * `{:ok, map}` - Map with IPs matching the banner pattern
    * `{:error, reason}` - Error tuple

  ## Examples

      # Find nginx servers
      {:ok, results} = PureSignalScout.Hunt.banner(client, "nginx")

      # Search within specific IPs
      {:ok, results} = PureSignalScout.Hunt.banner(client, "Apache",
        ips: ["192.168.1.1", "192.168.1.2"],
        limit: 50
      )
  """
  @spec banner(Client.t(), String.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def banner(client, pattern, opts \\ []) do
    body =
      %{pattern: pattern}
      |> maybe_put(:ips, opts[:ips])
      |> maybe_put(:limit, opts[:limit])

    Client.post(client, "/v1/investigate/hunt-banner", body)
  end

  @doc """
  Hunt for IPs by certificate common name.

  ## Parameters

    * `client` - A Scout client
    * `cn` - Certificate common name pattern to search for
    * `opts` - Optional parameters:
      * `:ips` - List of IPs to search within
      * `:limit` - Maximum results

  ## Returns

    * `{:ok, map}` - Map with IPs matching the certificate CN
    * `{:error, reason}` - Error tuple

  ## Examples

      # Find Google certificates
      {:ok, results} = PureSignalScout.Hunt.cert(client, "*.google.com")

      # Search within specific IPs
      {:ok, results} = PureSignalScout.Hunt.cert(client, "*.example.com",
        ips: some_ip_list,
        limit: 100
      )
  """
  @spec cert(Client.t(), String.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def cert(client, cn, opts \\ []) do
    body =
      %{cn: cn}
      |> maybe_put(:ips, opts[:ips])
      |> maybe_put(:limit, opts[:limit])

    Client.post(client, "/v1/investigate/hunt-cert", body)
  end

  @doc """
  Enrich X.509 certificate data.

  ## Parameters

    * `client` - A Scout client
    * `cert_hash` - SHA256 hash of the certificate

  ## Returns

    * `{:ok, map}` - Map with certificate details and associated IPs
    * `{:error, reason}` - Error tuple

  ## Examples

      {:ok, cert_info} = PureSignalScout.Hunt.enrich_x509(client,
        "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
      )
  """
  @spec enrich_x509(Client.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def enrich_x509(client, cert_hash) do
    Client.post(client, "/v1/investigate/enrich-x509", %{cert_hash: cert_hash})
  end

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)
end
