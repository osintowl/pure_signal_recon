defmodule PureSignalRecon.Host do
  @moduledoc """
  Host information queries for Pure Signal Recon.

  Get detailed host information including ports, services, and banners.
  """

  alias PureSignalRecon.Client

  @doc """
  Get host details from Recon database.

  ## Parameters

    * `client` - A Recon client
    * `ip` - IP address to lookup

  ## Returns

    * `{:ok, map}` - Map with host details (ports, services, banners, certs)
    * `{:error, reason}` - Error tuple

  ## Examples

      {:ok, host} = PureSignalRecon.Host.get(client, "8.8.8.8")
  """
  @spec get(Client.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def get(client, ip) do
    Client.get(client, "/host/#{ip}")
  end
end
