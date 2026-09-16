defmodule PureSignalRecon.Estimate do
  @moduledoc """
  Functions for estimating the number of flows that may be returned from a query.
  """

  alias PureSignalRecon.Client

  @doc """
  Estimates the number of Flows that may be returned from a given query.

  This is equivalent to the Flows Estimator tool on the Create Query page.

  Limited to 10 hits per day.

  ## Parameters

    * `ips_or_cidrs` - A comma separated list of IPs or CIDRs (required)
    * `start_date` - The start date from which you would like to estimate (required)
    * `end_date` - The end date from which you would like to estimate (required)

  ## Examples

      iex> PureSignalRecon.Estimate.flows(client, %{
      ...>   ips_or_cidrs: "8.8.8.8,1.1.1.1",
      ...>   start_date: "2024-01-01T00:00:00Z",
      ...>   end_date: "2024-01-02T00:00:00Z"
      ...> })
      {:ok, %{"estimated_flows" => 1000000}}
  """
  @spec flows(Client.t(), map()) :: {:ok, map()} | {:error, term()}
  def flows(%Client{} = client, params) do
    Client.post(client, "/estimate", params)
  end
end
