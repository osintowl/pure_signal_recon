defmodule PureSignalRecon.Certs do
  @moduledoc """
  SSL/TLS certificate queries for Pure Signal Recon.

  Get certificate information for domains or IP addresses.
  """

  alias PureSignalRecon.Client

  @doc """
  Get SSL/TLS certificate information for a domain or IP.

  ## Parameters

    * `client` - A Recon client
    * `target` - Domain name or IP address
    * `opts` - Optional parameters:
      * `:limit` - Maximum certificates to return

  ## Returns

    * `{:ok, map}` - Map with certificate data
    * `{:error, reason}` - Error tuple

  ## Examples

      {:ok, certs} = PureSignalRecon.Certs.get(client, "example.com")
      {:ok, certs} = PureSignalRecon.Certs.get(client, "8.8.8.8", limit: 10)
  """
  @spec get(Client.t(), String.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def get(client, target, opts \\ []) do
    params = build_params(opts, [:limit])
    Client.get(client, "/certs/#{URI.encode(target)}", params: params)
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
