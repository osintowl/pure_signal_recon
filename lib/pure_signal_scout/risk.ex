defmodule PureSignalScout.Risk do
  @moduledoc """
  Risk scoring operations for Pure Signal Scout.

  Get risk scores for IPs based on Team Cymru's threat intelligence.
  """

  alias PureSignalScout.Client

  @max_bulk_ips 20

  @doc """
  Get risk scores for one or more IPs.

  Automatically chunks requests at 20 IPs to avoid empty results.

  ## Parameters

    * `client` - A Scout client
    * `ip_or_ips` - Single IP address or list of IPs

  ## Returns

    * `{:ok, list}` - List of risk score results
    * `{:error, reason}` - Error tuple

  ## Examples

      # Single IP
      {:ok, risks} = PureSignalScout.Risk.get(client, "8.8.8.8")

      # Multiple IPs
      {:ok, risks} = PureSignalScout.Risk.get(client, ["8.8.8.8", "1.1.1.1"])
  """
  @spec get(Client.t(), String.t() | [String.t()]) :: {:ok, list()} | {:error, term()}
  def get(client, ip) when is_binary(ip) do
    get(client, [ip])
  end

  def get(client, ips) when is_list(ips) do
    ips
    |> Enum.chunk_every(@max_bulk_ips)
    |> Enum.reduce_while({:ok, []}, fn chunk, {:ok, acc} ->
      case Client.post(client, "/v1/investigate/risk", %{ips: chunk}) do
        {:ok, results} when is_list(results) -> {:cont, {:ok, acc ++ results}}
        {:ok, result} when is_map(result) -> {:cont, {:ok, acc ++ [result]}}
        {:error, _} = error -> {:halt, error}
      end
    end)
  end
end
