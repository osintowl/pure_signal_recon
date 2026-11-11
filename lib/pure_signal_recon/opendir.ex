defmodule PureSignalRecon.OpenDir do
  @moduledoc """
  Open directory hunting for Pure Signal Recon.

  Search for exposed open directories on web servers. Open directories
  are often used by threat actors for staging malware, stolen data, or tools.
  """

  alias PureSignalRecon.Client

  @doc """
  Search for open directories.

  ## Parameters

    * `client` - A Recon client
    * `query` - Search query (IP, domain, keyword, or CIDR range)
    * `opts` - Optional parameters:
      * `:filter` - Filter string (e.g., "http.opendir" or "https.opendir")
      * `:limit` - Maximum number of results (default: 100)

  ## Returns

    * `{:ok, map}` - Map with open directory findings
    * `{:error, reason}` - Error tuple

  ## Examples

      {:ok, results} = PureSignalRecon.OpenDir.search(client, "8.8.8.8")
      {:ok, results} = PureSignalRecon.OpenDir.search(client, "malware", limit: 50)
  """
  @spec search(Client.t(), String.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def search(client, query, opts \\ []) do
    params =
      [{:q, query}]
      |> add_param(opts, :filter)
      |> add_param(opts, :limit)

    Client.get(client, "/search/opendir", params: params)
  end

  @doc """
  Get detailed open directory information for a specific target.

  ## Parameters

    * `client` - A Recon client
    * `target` - IP address or domain

  ## Returns

    * `{:ok, map}` - Map with detailed open directory information
    * `{:error, reason}` - Error tuple

  ## Examples

      {:ok, details} = PureSignalRecon.OpenDir.get(client, "192.168.1.1")
  """
  @spec get(Client.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def get(client, target) do
    Client.get(client, "/opendir/#{URI.encode(target)}")
  end

  defp add_param(params, opts, key) do
    case Keyword.get(opts, key) do
      nil -> params
      value -> [{key, value} | params]
    end
  end
end
