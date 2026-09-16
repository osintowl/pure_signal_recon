defmodule PureSignalRecon.Stats do
  @moduledoc """
  Functions for retrieving statistics and usage information.
  """

  alias PureSignalRecon.Client

  @doc """
  Retrieves current user and organization statistics and limits.

  Returns information including:
  - User seats and limits
  - Product name and offering
  - Queries used and remaining
  - Scheduled jobs pending
  - Storage usage
  - Maximum query limits
  - Query sharing settings

  ## Examples

      iex> PureSignalRecon.Stats.get(client)
      {:ok, %{
        "user_seats" => 10,
        "product_name" => "Recon",
        "user_queries_used" => 5,
        "organization_queries_remaining" => 995,
        "max_cidr_size" => 24,
        "organization_max_bytes" => 1073741824,
        ...
      }}
  """
  @spec get(Client.t()) :: {:ok, map()} | {:error, term()}
  def get(%Client{} = client) do
    Client.get(client, "/stats")
  end
end
