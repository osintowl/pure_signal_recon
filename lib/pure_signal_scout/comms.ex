defmodule PureSignalScout.Comms do
  @moduledoc """
  Communication peers (netflow) analysis for Pure Signal Scout.

  Provides network flow data showing which IPs communicate with each other,
  on which ports, and using which protocols.

  ## Use Cases

  - **Who does this IP talk to?** - Identify communication peers
  - **Remote access detection** - Find RDP (3389), SSH (22), TeamViewer (5938), AnyDesk (7070)
  - **Exfiltration paths** - Detect SMB (445), FTP (21), unusual outbound
  - **ICS/SCADA contact** - Modbus (502), S7 (102), BACnet (47808), DNP3 (20000)
  """

  alias PureSignalScout.Client

  @doc """
  Get communication peers for an IP within a time window.

  ## Parameters

    * `client` - A Scout client
    * `ip` - IP address to investigate
    * `opts` - Optional parameters:
      * `:start_time` - Start of time window (ISO8601 or Unix timestamp)
      * `:end_time` - End of time window (ISO8601 or Unix timestamp)
      * `:limit` - Maximum number of peers to return

  ## Returns

    * `{:ok, map}` - Map with communication peers, ports, protocols
    * `{:error, reason}` - Error tuple

  ## Examples

      # Basic lookup
      {:ok, comms} = PureSignalScout.Comms.get(client, "192.168.1.1")

      # With time window
      {:ok, comms} = PureSignalScout.Comms.get(client, "192.168.1.1",
        start_time: "2024-01-01T00:00:00Z",
        end_time: "2024-01-02T00:00:00Z",
        limit: 100
      )
  """
  @spec get(Client.t(), String.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def get(client, ip, opts \\ []) do
    body =
      %{ip: ip}
      |> maybe_put(:start_time, opts[:start_time])
      |> maybe_put(:end_time, opts[:end_time])
      |> maybe_put(:limit, opts[:limit])

    Client.post(client, "/v1/investigate/comms", body)
  end

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)
end
