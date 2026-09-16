defmodule PureSignalRecon.Jobs do
  @moduledoc """
  Functions for managing jobs in the Pure Signal Recon API.

  Jobs represent query executions that can contain multiple search queries
  across different query types.
  """

  alias PureSignalRecon.Client

  @doc """
  Creates a new job with the given parameters.

  ## Parameters

    * `job_name` - The name of the job (required)
    * `job_description` - Description of the job (optional)
    * `start_date` - Beginning date to search for (required, ISO 8601 format)
    * `end_date` - Ending date to search for (required, ISO 8601 format)
    * `timeout` - Maximum time to spend querying each query type (optional)
    * `priority` - Job priority (1-10, default 5) (optional)
    * `group_id` - Group Team ID for the job query (optional)
    * `queries` - Array of query objects (required)

  ## Examples

      iex> PureSignalRecon.Jobs.create(client, %{
      ...>   job_name: "Example Job",
      ...>   job_description: "This job is just an example",
      ...>   start_date: "2024-01-01T00:00:00Z",
      ...>   end_date: "2024-01-02T00:00:00Z",
      ...>   priority: 5,
      ...>   queries: [
      ...>     %{query_type: "flows", any_ip_addr: "8.8.8.8"}
      ...>   ]
      ...> })
      {:ok, %{"id" => 123, ...}}
  """
  @spec create(Client.t(), map()) :: {:ok, map()} | {:error, term()}
  def create(%Client{} = client, params) do
    Client.post(client, "/jobs", params)
  end

  @doc """
  Lists all jobs with optional filtering.

  ## Parameters

    * `search` - String search for matching job name (optional)
    * `group_id` - Group Team ID for the jobs to be returned (optional)
    * `start_date` - The start date of the search time range (optional)
    * `end_date` - The end date of the search time range (optional)
    * `system_origin` - Origin of how jobs were created: schedule, web, or api (optional)
    * `status` - Status of jobs: completed, started, or pending (optional)
    * `page` - Page number of jobs to be returned (optional)
    * `per_page` - Number of jobs returned at one time (optional)

  ## Examples

      iex> PureSignalRecon.Jobs.list(client)
      {:ok, %{"data" => [...], "pagination" => %{...}}}

      iex> PureSignalRecon.Jobs.list(client, search: "my_job")
      {:ok, %{"data" => [...], "pagination" => %{...}}}
  """
  @spec list(Client.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def list(%Client{} = client, params \\ []) do
    Client.get(client, "/jobs", params: params)
  end

  @doc """
  Gets detailed information about a specific job.

  ## Examples

      iex> PureSignalRecon.Jobs.get_details(client, 123)
      {:ok, %{"id" => 123, "job_name" => "Example Job", ...}}
  """
  @spec get_details(Client.t(), integer()) :: {:ok, map()} | {:error, term()}
  def get_details(%Client{} = client, job_id) do
    Client.get(client, "/jobs/#{job_id}/details")
  end

  @doc """
  Gets all results from a specific job.

  Returns a file with all query results combined.

  ## Parameters

    * `job_id` - The ID of the job (required)
    * `format` - Format to return results in: csv, json, xml, xlsx (default: json)

  ## Examples

      iex> PureSignalRecon.Jobs.get_results(client, 123)
      {:ok, results_data}

      iex> PureSignalRecon.Jobs.get_results(client, 123, format: "csv")
      {:ok, csv_data}
  """
  @spec get_results(Client.t(), integer(), keyword()) :: {:ok, String.t() | map()} | {:error, term()}
  def get_results(%Client{} = client, job_id, opts \\ []) do
    params = if format = Keyword.get(opts, :format), do: [format: format], else: []
    Client.get(client, "/jobs/#{job_id}", params: params)
  end

  @doc """
  Deletes a specific job and all its results.

  ## Examples

      iex> PureSignalRecon.Jobs.delete(client, 123)
      {:ok, %{"message" => "Job deleted"}}
  """
  @spec delete(Client.t(), integer()) :: {:ok, map()} | {:error, term()}
  def delete(%Client{} = client, job_id) do
    Client.delete(client, "/jobs/#{job_id}")
  end

  @doc """
  Bulk deletes multiple jobs by their IDs.

  Limited to 1 request per minute.

  ## Examples

      iex> PureSignalRecon.Jobs.delete_bulk(client, [123, 456, 789])
      {:ok, %{"deleted" => 3}}
  """
  @spec delete_bulk(Client.t(), list(integer())) :: {:ok, map()} | {:error, term()}
  def delete_bulk(%Client{} = client, job_ids) when is_list(job_ids) do
    Client.delete(client, "/jobs/ids", body: %{ids: job_ids})
  end

  @doc """
  Bulk deletes jobs within a specified date range.

  Limited to 1 request per minute.

  ## Parameters

    * `start_date` - The start date of the search time range (required)
    * `end_date` - The end date of the search time range (required)

  ## Examples

      iex> PureSignalRecon.Jobs.delete_by_date_range(client, "2024-01-01T00:00:00Z", "2024-01-02T00:00:00Z")
      {:ok, %{"deleted" => 5}}
  """
  @spec delete_by_date_range(Client.t(), String.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def delete_by_date_range(%Client{} = client, start_date, end_date) do
    Client.delete(client, "/jobs/date", body: %{start_date: start_date, end_date: end_date})
  end
end
