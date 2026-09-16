# PureSignalRecon

Elixir client for the [Team Cymru Pure Signal Recon API](https://www.team-cymru.com/post/introducing-pure-signal-recon). This library provides a simple interface to interact with the Pure Signal Recon API, allowing you to query network flow data, malware reports, manage jobs and schedules, and more.

## Features

- **Jobs Management** - Create, list, retrieve, and delete query jobs
- **Scheduled Jobs** - Automate recurring queries with flexible intervals
- **Malware Intelligence** - Search and retrieve malware reports by various indicators
- **Network Flow Analysis** - Query and analyze network flow data
- **Geographic Queries** - Search IPs by geographic coordinates
- **Tagged IPs** - Manage IP tagging for tracking and filtering
- **Statistics** - Retrieve usage and quota information
- **Results Export** - Export results in multiple formats (JSON, CSV, XML, XLSX)
- **Flow Estimation** - Estimate potential result sizes before running queries

## Installation

Add `pure_signal_recon` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:pure_signal_recon, "~> 0.1.0"},
    {:req, "~> 0.5"}
  ]
end
```

## Configuration

You can configure the API key and base URL in your application config:

```elixir
config :pure_signal_recon,
  api_key: System.get_env("PURE_SIGNAL_API_KEY"),
  base_url: "https://recon.cymru.com/api"
```

Or pass them directly when creating a client:

```elixir
client = PureSignalRecon.new(api_key: "your_api_key_here")
```

## Quick Start

```elixir
# Create a client
client = PureSignalRecon.new(api_key: "your_api_key")

# Create a job to query network flows
{:ok, job} = PureSignalRecon.Jobs.create(client, %{
  job_name: "DNS Traffic Analysis",
  job_description: "Analyzing DNS queries to 8.8.8.8",
  start_date: "2024-01-01T00:00:00Z",
  end_date: "2024-01-02T00:00:00Z",
  priority: 5,
  queries: [
    %{query_type: "flows", any_ip_addr: "8.8.8.8"}
  ]
})

# Get job details
{:ok, details} = PureSignalRecon.Jobs.get_details(client, job["id"])

# List all jobs
{:ok, jobs} = PureSignalRecon.Jobs.list(client)

# Get job results in CSV format
{:ok, results} = PureSignalRecon.Jobs.get_results(client, job["id"], format: "csv")
```

## Usage Examples

### Malware Intelligence

```elixir
# Search for malware by IP address
{:ok, results} = PureSignalRecon.Malware.search(client, %{
  search_type: "ip",
  search_term: "192.168.1.1",
  page: 1,
  page_length: 50
})

# Get detailed malware report by hash
{:ok, report} = PureSignalRecon.Malware.get_details(client, 
  "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
)
```

### Scheduled Jobs

```elixir
# Create a recurring job that runs daily
{:ok, schedule} = PureSignalRecon.Schedules.create(client, %{
  job_id: job["id"],
  interval: "1day"
})

# List all scheduled jobs
{:ok, schedules} = PureSignalRecon.Schedules.list(client)

# Delete a schedule
{:ok, _} = PureSignalRecon.Schedules.delete(client, schedule["id"])
```

### Geographic Queries

```elixir
# Find IPs within 50km of coordinates
{:ok, geo_ips} = PureSignalRecon.Maps.get_geo_ips(client, %{
  latitude: 37.7749,
  longitude: -122.4194,
  distance: 50,
  unit: "km"
})
```

### Tagged IPs

```elixir
# Upload tagged IPs from a CSV file
{:ok, result} = PureSignalRecon.TaggedIPs.insert_from_file(client, 
  "/path/to/tagged_ips.csv"
)

# Delete tagged IPs from a file
{:ok, _} = PureSignalRecon.TaggedIPs.delete_from_file(client,
  "/path/to/ips_to_remove.csv"
)
```

### Statistics and Usage

```elixir
# Get account statistics and limits
{:ok, stats} = PureSignalRecon.Stats.get(client)

IO.inspect(stats)
# %{
#   "queries_used" => 150,
#   "queries_remaining" => 850,
#   "storage_used_gb" => 2.5,
#   ...
# }
```

### Flow Estimation

```elixir
# Estimate flow data size before running a query
{:ok, estimate} = PureSignalRecon.Estimate.flows(client, %{
  ips_or_cidrs: "8.8.8.8,1.1.1.1",
  start_date: "2024-01-01T00:00:00Z",
  end_date: "2024-01-02T00:00:00Z"
})
```

### Results Management

```elixir
# Get specific query result from a job
{:ok, result} = PureSignalRecon.Results.get(client, result_id, 
  format: "json",
  data_variant: "conversations"
)

# Download result to file
{:ok, filepath} = PureSignalRecon.Results.download(client, result_id,
  "/path/to/output.json"
)
```

## API Modules

- `PureSignalRecon` - Main module and client creation
- `PureSignalRecon.Jobs` - Job management and execution
- `PureSignalRecon.Schedules` - Scheduled/recurring jobs
- `PureSignalRecon.Results` - Query result retrieval and export
- `PureSignalRecon.Malware` - Malware report searches
- `PureSignalRecon.Maps` - Geographic IP queries
- `PureSignalRecon.TaggedIPs` - IP tagging operations
- `PureSignalRecon.Tags` - Tag and category exports
- `PureSignalRecon.Stats` - Usage statistics and limits
- `PureSignalRecon.Estimate` - Flow query estimation
- `PureSignalRecon.Client` - Low-level HTTP client (internal)

## Error Handling

All API functions return either `{:ok, result}` or `{:error, reason}`:

```elixir
case PureSignalRecon.Jobs.create(client, params) do
  {:ok, job} ->
    IO.puts("Job created with ID: #{job["id"]}")
    
  {:error, :authentication_error} ->
    IO.puts("Invalid API key")
    
  {:error, :rate_limit_exceeded} ->
    IO.puts("Rate limit exceeded, please wait")
    
  {:error, {:validation_error, details}} ->
    IO.puts("Validation error: #{inspect(details)}")
    
  {:error, reason} ->
    IO.puts("Error: #{inspect(reason)}")
end
```

## Rate Limits

Be aware of API rate limits:
- Bulk delete operations: 1 request per minute
- Flow estimation: 10 requests per day

The client automatically retries transient errors up to 3 times.

## Testing

Run the test suite:

```bash
mix test
```

## Documentation

Generate documentation locally:

```bash
mix docs
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This library is released under the BSD 3-Clause License.

## Links

- [Team Cymru Pure Signal Recon](https://www.team-cymru.com/post/introducing-pure-signal-recon)
- [API Documentation](https://recon.cymru.com/api/docs)
