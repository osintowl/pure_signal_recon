defmodule PureSignalRecon.Client do
  @moduledoc """
  HTTP client for the Pure Signal Recon API.
  """

  @type t :: %__MODULE__{
          api_key: String.t(),
          base_url: String.t(),
          req: Req.Request.t()
        }

  defstruct [:api_key, :base_url, :req]

  @doc """
  Creates a new client instance.
  """
  @spec new(keyword()) :: t()
  def new(opts) do
    api_key = Keyword.fetch!(opts, :api_key)
    base_url = Keyword.fetch!(opts, :base_url)

    req =
      Req.new(
        base_url: base_url,
        headers: [
          {"authorization", "Token #{api_key}"},
          {"content-type", "application/json"}
        ],
        retry: :transient,
        max_retries: 3
      )

    %__MODULE__{
      api_key: api_key,
      base_url: base_url,
      req: req
    }
  end

  @doc """
  Performs a GET request.
  """
  @spec get(t(), String.t(), keyword()) :: {:ok, map() | String.t()} | {:error, term()}
  def get(%__MODULE__{req: req}, path, opts \\ []) do
    case Req.get(req, url: path, params: Keyword.get(opts, :params, [])) do
      {:ok, %{status: status, body: body}} when status in 200..299 ->
        {:ok, body}

      {:ok, %{status: 401}} ->
        {:error, :authentication_error}

      {:ok, %{status: 403}} ->
        {:error, :authorization_error}

      {:ok, %{status: 422, body: body}} ->
        {:error, {:validation_error, body}}

      {:ok, %{status: 429}} ->
        {:error, :rate_limit_exceeded}

      {:ok, %{status: 500}} ->
        {:error, :internal_server_error}

      {:ok, %{status: status, body: body}} ->
        {:error, {:unexpected_status, status, body}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Performs a POST request.
  """
  @spec post(t(), String.t(), map() | keyword(), keyword()) ::
          {:ok, map() | String.t()} | {:error, term()}
  def post(%__MODULE__{req: req}, path, data, opts \\ []) do
    body = if Keyword.get(opts, :multipart), do: {:multipart, data}, else: {:json, data}

    case Req.post(req, url: path, body: body) do
      {:ok, %{status: status, body: body}} when status in 200..299 ->
        {:ok, body}

      {:ok, %{status: 401}} ->
        {:error, :authentication_error}

      {:ok, %{status: 403}} ->
        {:error, :authorization_error}

      {:ok, %{status: 422, body: body}} ->
        {:error, {:validation_error, body}}

      {:ok, %{status: 429}} ->
        {:error, :rate_limit_exceeded}

      {:ok, %{status: 500}} ->
        {:error, :internal_server_error}

      {:ok, %{status: status, body: body}} ->
        {:error, {:unexpected_status, status, body}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Performs a DELETE request.
  """
  @spec delete(t(), String.t(), keyword()) :: {:ok, map() | String.t()} | {:error, term()}
  def delete(%__MODULE__{req: req}, path, opts \\ []) do
    request_opts = [url: path]
    request_opts = if data = Keyword.get(opts, :body), do: Keyword.put(request_opts, :json, data), else: request_opts

    case Req.delete(req, request_opts) do
      {:ok, %{status: status, body: body}} when status in 200..299 ->
        {:ok, body}

      {:ok, %{status: 401}} ->
        {:error, :authentication_error}

      {:ok, %{status: 403}} ->
        {:error, :authorization_error}

      {:ok, %{status: 422, body: body}} ->
        {:error, {:validation_error, body}}

      {:ok, %{status: 429}} ->
        {:error, :rate_limit_exceeded}

      {:ok, %{status: 500}} ->
        {:error, :internal_server_error}

      {:ok, %{status: status, body: body}} ->
        {:error, {:unexpected_status, status, body}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Performs a HEAD request.

  Useful for checking if a job or result is ready without downloading the full response.
  Returns :ok for 200 status, {:processing, 206} for incomplete jobs, or an error.
  """
  @spec head(t(), String.t(), keyword()) :: :ok | {:processing, 206} | {:error, term()}
  def head(%__MODULE__{req: req}, path, opts \\ []) do
    case Req.head(req, url: path, params: Keyword.get(opts, :params, [])) do
      {:ok, %{status: 200}} ->
        :ok

      {:ok, %{status: 206}} ->
        {:processing, 206}

      {:ok, %{status: 401}} ->
        {:error, :authentication_error}

      {:ok, %{status: 403}} ->
        {:error, :authorization_error}

      {:ok, %{status: 404}} ->
        {:error, :not_found}

      {:ok, %{status: 429}} ->
        {:error, :rate_limit_exceeded}

      {:ok, %{status: 500}} ->
        {:error, :internal_server_error}

      {:ok, %{status: status}} ->
        {:error, {:unexpected_status, status}}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
