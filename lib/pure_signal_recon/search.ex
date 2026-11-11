defmodule PureSignalRecon.Search do
  @moduledoc """
  General search operations for Pure Signal Recon.

  Search for infrastructure in the Recon database.
  """

  alias PureSignalRecon.Client

  @doc """
  Search for infrastructure in the Recon database.

  ## Parameters

    * `client` - A Recon client
    * `query` - Search query (IP, domain, CIDR, or keyword)
    * `opts` - Optional parameters:
      * `:type` - Search type (ip, domain, cidr, cert)
      * `:limit` - Maximum results (default: 100)
      * `:offset` - Pagination offset

  ## Returns

    * `{:ok, map}` - Map with infrastructure search results
    * `{:error, reason}` - Error tuple

  ## Examples

      {:ok, results} = PureSignalRecon.Search.query(client, "8.8.8.8")
      {:ok, results} = PureSignalRecon.Search.query(client, "192.168.0.0/16", type: "cidr")
  """
  @spec query(Client.t(), String.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def query(client, query_string, opts \\ []) do
    params =
      [{:q, query_string}]
      |> add_param(opts, :type)
      |> add_param(opts, :limit)
      |> add_param(opts, :offset)

    Client.get(client, "/search", params: params)
  end

  defp add_param(params, opts, key) do
    case Keyword.get(opts, key) do
      nil -> params
      value -> [{key, value} | params]
    end
  end
end
