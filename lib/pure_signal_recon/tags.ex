defmodule PureSignalRecon.Tags do
  @moduledoc """
  Functions for exporting tag and category information.
  """

  alias PureSignalRecon.Client

  @doc """
  Returns a CSV file of category information.

  This endpoint exports all available tag and category data in CSV format.

  ## Examples

      iex> PureSignalRecon.Tags.export(client)
      {:ok, csv_data}
  """
  @spec export(Client.t()) :: {:ok, String.t()} | {:error, term()}
  def export(%Client{} = client) do
    Client.get(client, "/tags/export")
  end
end
