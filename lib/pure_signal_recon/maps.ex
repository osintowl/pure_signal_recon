defmodule PureSignalRecon.Maps do
  @moduledoc """
  Functions for querying geographic and IP-based data.
  """

  alias PureSignalRecon.Client

  @doc """
  Gets the list of GEO IPs based on a set of coordinates and radius.

  ## Parameters

    * `latitude` - Numeric value representing the latitude of a location (required)
      Valid range: -90.0 to 90.0
    * `longitude` - Numeric value representing the longitude of a location (required)
      Valid range: -180.0 to 180.0
    * `distance` - Absolute numeric value representing the radius distance from the geolocation (optional)
      Maximum value: 40075 (Earth's circumference in km)
    * `unit` - Unit of distance: "km" or "mi" (default: "km")

  ## Examples

      iex> PureSignalRecon.Maps.query_by_geo(client, %{
      ...>   latitude: 37.7749,
      ...>   longitude: -122.4194,
      ...>   distance: 50,
      ...>   unit: "km"
      ...> })
      {:ok, [...]}
  """
  @spec query_by_geo(Client.t(), map()) :: {:ok, list()} | {:error, term()}
  def query_by_geo(%Client{} = client, params) do
    Client.get(client, "/maps/geo", params: Map.to_list(params))
  end

  @doc """
  Gets the list of GEO IPs based on an IP address.

  ## Parameters

    * `ip_address` - IP CIDR to be used (required)

  ## Examples

      iex> PureSignalRecon.Maps.query_by_ip(client, %{ip_address: "8.8.8.8"})
      {:ok, [...]}
  """
  @spec query_by_ip(Client.t(), map()) :: {:ok, list()} | {:error, term()}
  def query_by_ip(%Client{} = client, params) do
    Client.get(client, "/maps/ip", params: Map.to_list(params))
  end
end
