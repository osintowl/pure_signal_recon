defmodule PureSignalRecon.Schedules do
  @moduledoc """
  Functions for managing scheduled jobs in the Pure Signal Recon API.

  Scheduled jobs allow you to automatically execute queries at regular intervals.
  """

  alias PureSignalRecon.Client

  @doc """
  Creates a new scheduled job.

  ## Parameters

    * `job_id` - The name of the job to be scheduled (required)
    * `interval` - The interval of the scheduled job (required). Must be one of:
      - `"1hour"` or `"1hours"`
      - `"6hours"`
      - `"12hours"`
      - `"1day"` or `"1days"`
      - `"7days"`
      - `"1month"`

  ## Examples

      iex> PureSignalRecon.Schedules.create(client, %{
      ...>   job_id: 123,
      ...>   interval: "1day"
      ...> })
      {:ok, %{"id" => 1, "job_id" => 123, "interval" => "1day", ...}}
  """
  @spec create(Client.t(), map()) :: {:ok, map()} | {:error, term()}
  def create(%Client{} = client, params) do
    Client.post(client, "/schedules", params)
  end

  @doc """
  Lists all scheduled jobs for the organization.

  ## Parameters

    * `organization_id` - The organization ID for the scheduled jobs to be returned (optional)
    * `page` - The page number of the scheduled jobs to be returned (optional)
    * `per_page` - The number of scheduled jobs returned at one time (optional)
    * `sort` - Sorting options, e.g., `sort[created_at]=desc` (optional)
    * `order` - The field by which the data returned should be ordered (optional)

  ## Examples

      iex> PureSignalRecon.Schedules.list(client)
      {:ok, %{"data" => [...], "pagination" => %{...}}}

      iex> PureSignalRecon.Schedules.list(client, page: 2, per_page: 10)
      {:ok, %{"data" => [...], "pagination" => %{...}}}
  """
  @spec list(Client.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def list(%Client{} = client, params \\ []) do
    Client.get(client, "/schedules", params: params)
  end

  @doc """
  Gets a specific scheduled job by ID.

  ## Examples

      iex> PureSignalRecon.Schedules.get(client, 1)
      {:ok, %{"id" => 1, "job_id" => 123, "interval" => "1day", ...}}
  """
  @spec get(Client.t(), integer()) :: {:ok, map()} | {:error, term()}
  def get(%Client{} = client, schedule_id) do
    Client.get(client, "/schedules/#{schedule_id}")
  end

  @doc """
  Deletes a specific scheduled job.

  ## Examples

      iex> PureSignalRecon.Schedules.delete(client, 1)
      {:ok, %{"message" => "Schedule deleted"}}
  """
  @spec delete(Client.t(), integer()) :: {:ok, map()} | {:error, term()}
  def delete(%Client{} = client, schedule_id) do
    Client.delete(client, "/schedules/#{schedule_id}")
  end
end
