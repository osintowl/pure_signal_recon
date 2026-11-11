defmodule PureSignalScout.Pdns do
  @moduledoc """
  Passive DNS operations for Pure Signal Scout.

  Query historical DNS resolution data to see what domains
  have resolved to an IP address over time.
  """

  alias PureSignalScout.Client

  @doc """
  Get passive DNS records for an IP address.

  ## Parameters

    * `client` - A Scout client
    * `ip` - IP address to lookup

  ## Returns

    * `{:ok, map}` - Map with passive DNS records (domains that resolved to this IP)
    * `{:error, reason}` - Error tuple

  ## Examples

      {:ok, pdns} = PureSignalScout.Pdns.get(client, "8.8.8.8")
  """
  @spec get(Client.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def get(client, ip) when is_binary(ip) do
    Client.post(client, "/v1/investigate/pdns", %{ip: ip})
  end
end
