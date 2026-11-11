defmodule PureSignalRecon.Pdns do
  @moduledoc """
  Passive DNS queries for Pure Signal Recon.

  Query historical DNS resolution data for domains or IP addresses.
  """

  alias PureSignalRecon.Client

  @doc """
  Get passive DNS records for a domain or IP address.

  ## Parameters

    * `client` - A Recon client
    * `query` - Domain name or IP address
    * `opts` - Optional parameters:
      * `:limit` - Maximum number of records to return (default: 100)
      * `:type` - Record type filter (A, AAAA, CNAME, etc.)

  ## Returns

    * `{:ok, map}` - Map with passive DNS records
    * `{:error, reason}` - Error tuple

  ## Examples

      {:ok, pdns} = PureSignalRecon.Pdns.get(client, "example.com")
      {:ok, pdns} = PureSignalRecon.Pdns.get(client, "8.8.8.8", limit: 50)
  """
  @spec get(Client.t(), String.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def get(client, query, opts \\ []) do
    params = build_params(opts, [:limit, :type])
    Client.get(client, "/pdns/#{URI.encode(query)}", params: params)
  end

  defp build_params(opts, keys) do
    Enum.reduce(keys, [], fn key, acc ->
      case Keyword.get(opts, key) do
        nil -> acc
        value -> [{key, value} | acc]
      end
    end)
  end
end
