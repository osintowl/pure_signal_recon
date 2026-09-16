defmodule PureSignalRecon.TaggedIPs do
  @moduledoc """
  Functions for managing tagged IPs in bulk operations.

  Tagged IPs allow you to mark specific IP addresses with metadata like comments
  and expiration dates for tracking and filtering purposes.
  """

  alias PureSignalRecon.Client

  @doc """
  Inserts one or many tagged IPs from a file.

  The file should be in CSV or JSON format.

  ## CSV File Format

  The CSV file should contain the following fields:
  - `ip_addr` - The IP CIDR to be tagged (required)
  - `comments` - Comments about the IP to be tagged (optional, default: "Cloudflare Public DNS")
  - `expiration_date` - The date the tagged IP will expire in YYYY-MM-DD format (optional)
  - `highlighting_id` - The User Defined Highlighting ID (optional)

  Extra fields will be ignored. If a field is present and contains a value, it will be validated.
  Times are set to 00:00:00 GMT.

  ## Parameters

    * `file` - Location of valid CSV or JSON file (required)
    * `type` - The type of the file: csv or json (required)

  ## Examples

      iex> PureSignalRecon.TaggedIPs.create_bulk(client, "/path/to/file.csv", "csv")
      {:ok, %{"created" => 10}}
  """
  @spec create_bulk(Client.t(), String.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def create_bulk(%Client{} = client, file_path, file_type) do
    multipart_data = [
      {:file, file_path},
      {"type", file_type}
    ]

    Client.post(client, "/tagged-ips/bulk-create", multipart_data, multipart: true)
  end

  @doc """
  Updates one or many tagged IPs from a file.

  If a tagged IP exists for your organization, the comments and expiration_date
  fields will be updated for that IP.

  ## CSV File Format

  Same as `create_bulk/3`.

  ## Parameters

    * `file` - Location of valid CSV or JSON file (required)
    * `type` - The type of the file: csv or json (required)

  ## Examples

      iex> PureSignalRecon.TaggedIPs.update_bulk(client, "/path/to/file.csv", "csv")
      {:ok, %{"updated" => 5}}
  """
  @spec update_bulk(Client.t(), String.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def update_bulk(%Client{} = client, file_path, file_type) do
    multipart_data = [
      {:file, file_path},
      {"type", file_type}
    ]

    Client.post(client, "/tagged-ips/bulk-update", multipart_data, multipart: true)
  end

  @doc """
  Deletes one or many tagged IPs from a file.

  ## CSV File Format

  The file only needs the `ip_addr` field:
  - `ip_addr` - The IP CIDR to be deleted (required)

  ## Parameters

    * `file` - Location of valid CSV or JSON file (required)
    * `type` - The type of the file: csv or json (required)

  ## Examples

      iex> PureSignalRecon.TaggedIPs.delete_bulk(client, "/path/to/file.csv", "csv")
      {:ok, %{"deleted" => 3}}
  """
  @spec delete_bulk(Client.t(), String.t(), String.t()) :: {:ok, map()} | {:error, term()}
  def delete_bulk(%Client{} = client, file_path, file_type) do
    multipart_data = [
      {:file, file_path},
      {"type", file_type}
    ]

    Client.post(client, "/tagged-ips/bulk-delete", multipart_data, multipart: true)
  end
end
