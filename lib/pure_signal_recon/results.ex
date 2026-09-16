defmodule PureSignalRecon.Results do
  @moduledoc """
  Functions for managing query results in the Pure Signal Recon API.
  """

  alias PureSignalRecon.Client

  @doc """
  Gets the result from a single query within a job.

  ## Parameters

    * `result_id` - The ID of the query result (required)
    * `format` - Format to return results in: csv, json, xml, xlsx (default: json)
    * `data_variant` - The data variant parameter (optional):
      - `flows` - Results with role based columns and tags (default)
      - `conversations` - Results from the conversations tab
      - `initiators` - Results from the initiators tab
      - `historic` - Results without role based columns and tags
      - Other fields - Any result fields for the query type can be used to filter results

  ## Examples

      iex> PureSignalRecon.Results.get(client, 456)
      {:ok, result_data}

      iex> PureSignalRecon.Results.get(client, 456, format: "csv", data_variant: "flows")
      {:ok, csv_data}

      iex> PureSignalRecon.Results.get(client, 456, ip_addr: "8.8.8.8", cc: "US")
      {:ok, filtered_results}
  """
  @spec get(Client.t(), integer(), keyword()) :: {:ok, String.t() | map()} | {:error, term()}
  def get(%Client{} = client, result_id, opts \\ []) do
    params = Enum.into(opts, [])
    Client.get(client, "/results/#{result_id}", params: params)
  end

  @doc """
  Deletes the result from a single query.

  ## Examples

      iex> PureSignalRecon.Results.delete(client, 456)
      {:ok, %{"message" => "Result deleted"}}
  """
  @spec delete(Client.t(), integer()) :: {:ok, map()} | {:error, term()}
  def delete(%Client{} = client, result_id) do
    Client.delete(client, "/results/#{result_id}")
  end
end
