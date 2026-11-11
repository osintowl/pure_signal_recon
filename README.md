# PureSignal

Elixir client for the [Team Cymru Pure Signal](https://www.team-cymru.com/) platform. This library provides interfaces for both **Recon** (network flow analysis) and **Scout** (IP enrichment/threat intelligence) APIs.

## Features

### Scout (IP Enrichment & Threat Intelligence)

- **IP Summary** - Risk scores, infrastructure tags, ASN, geolocation
- **Communication Peers** - Netflow data showing who IPs talk to
- **Passive DNS** - Historical DNS resolution data
- **Risk Scoring** - Bulk risk assessment for IPs
- **Tag Pivoting** - Filter IPs by threat tags (malware, C2, Tor, etc.)
- **Infrastructure Hunting** - Find IPs by banner patterns or certificate CNs
- **Perimeter Sweeps** - Detect outbound traffic to malicious infrastructure

### Recon (Network Flow Analysis)

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
    {:pure_signal_recon, "~> 0.2.0"}
  ]
end
```

## Configuration

You can configure the API keys and base URLs in your application config:

```elixir
# Scout API (IP enrichment, threat intel)
config :pure_signal_recon,
  scout_api_key: System.get_env("PURE_SIGNAL_SCOUT_API_KEY"),
  scout_base_url: "https://scout.cymru.com/api"

# Recon API (network flows, jobs)
config :pure_signal_recon,
  api_key: System.get_env("PURE_SIGNAL_RECON_API_KEY"),
  base_url: "https://recon.cymru.com/api"
```

Or pass them directly when creating clients:

```elixir
scout = PureSignalScout.new(api_key: "your_scout_key")
recon = PureSignalRecon.new(api_key: "your_recon_key")
```

## Quick Start - Scout

```elixir
# Create a Scout client
scout = PureSignalScout.new(api_key: "your_api_key")

# Get IP summary with risk scores and tags
{:ok, summary} = PureSignalScout.Summary.get(scout, "8.8.8.8")

# Get communication peers (netflow)
{:ok, comms} = PureSignalScout.Comms.get(scout, "192.168.1.1",
  start_time: "2024-01-01T00:00:00Z",
  end_time: "2024-01-02T00:00:00Z"
)

# Get passive DNS records
{:ok, pdns} = PureSignalScout.Pdns.get(scout, "8.8.8.8")

# Bulk risk scores
{:ok, risks} = PureSignalScout.Risk.get(scout, ["8.8.8.8", "1.1.1.1"])

# Filter IPs by tags
{:ok, results} = PureSignalScout.Tags.pivot(scout, ips, ["malware", "controller"])

# Hunt by banner pattern
{:ok, results} = PureSignalScout.Hunt.banner(scout, "nginx")

# Hunt by certificate CN
{:ok, results} = PureSignalScout.Hunt.cert(scout, "*.google.com")

# Perimeter sweep for malicious outbound traffic
{:ok, results} = PureSignalScout.Advanced.perimeter_sweep(scout, ["10.0.0.0/8"],
  start_time: "2024-01-01T00:00:00Z",
  end_time: "2024-01-02T00:00:00Z"
)
```

## Quick Start - Recon

```elixir
# Create a Recon client
recon = PureSignalRecon.new(api_key: "your_api_key")

# Create a job to query network flows
{:ok, job} = PureSignalRecon.Jobs.create(recon, %{
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
{:ok, details} = PureSignalRecon.Jobs.get_details(recon, job["id"])

# List all jobs
{:ok, jobs} = PureSignalRecon.Jobs.list(recon)

# Get job results in CSV format
{:ok, results} = PureSignalRecon.Jobs.get_results(recon, job["id"], format: "csv")
```

## Scout Tag Reference

### Adversary Indicators

| Tag | Description |
|-----|-------------|
| `risknet` | Known risky network |
| `socks` | SOCKS proxy |
| `tor` | Tor exit node |
| `cobaltstrike` | Cobalt Strike beacon |
| `controller` | C2 controller |
| `bot` | Bot/botnet |
| `malware` | Known malware |
| `ost` | Offensive security tool |
| `orb` | Operational relay box |
| `open-dir` | Open directory |
| `res-proxy` | Residential proxy |

### Dual-Use Infrastructure

| Tag | Description |
|-----|-------------|
| `astrill-vpn` | Astrill VPN |
| `anydesk` | AnyDesk remote access |
| `warp-vpn` | Cloudflare WARP VPN |
| `pia` | Private Internet Access VPN |
| `1-vpn` | 1VPN service |

## API Modules

### Scout

- `PureSignalScout` - Main module and client creation
- `PureSignalScout.Summary` - IP summary and bulk enrichment
- `PureSignalScout.Comms` - Communication peers (netflow)
- `PureSignalScout.Pdns` - Passive DNS queries
- `PureSignalScout.Risk` - Risk scoring
- `PureSignalScout.Tags` - Tag-based filtering and pivoting
- `PureSignalScout.Hunt` - Banner and certificate hunting
- `PureSignalScout.Advanced` - Fan-in analysis, IP searches, perimeter sweeps
- `PureSignalScout.Client` - Low-level HTTP client (internal)

### Recon

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
case PureSignalScout.Summary.get(scout, ip) do
  {:ok, summary} ->
    IO.puts("Risk score: #{summary["risk_score"]}")
    
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

### Scout
- ~60 requests per window
- Bulk operations automatically chunk at 20 IPs

### Recon
- Bulk delete operations: 1 request per minute
- Flow estimation: 10 requests per day
- Reads are FREE - only job creation incurs billing

The clients automatically retry transient errors up to 3 times.

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

- [Team Cymru Pure Signal](https://www.team-cymru.com/)
- [Pure Signal Recon](https://www.team-cymru.com/post/introducing-pure-signal-recon)
- [Pure Signal Scout](https://www.team-cymru.com/pure-signal-scout)
- [Recon API Documentation](https://recon.cymru.com/api/docs)
- [Scout API Documentation](https://scout.cymru.com/api/docs)
