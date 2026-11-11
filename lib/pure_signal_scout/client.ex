defmodule PureSignalScout.Client do
  @moduledoc """
  HTTP client for the Pure Signal Scout API.

  Scout uses Bearer token authentication and JSON request/response format.
  All investigation endpoints use POST with JSON bodies.
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
          {"authorization", "Bearer #{api_key}"},
          {"content-type", "application/json"},
          {"accept", "application/json"}
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
  @spec get(t(), String.t(), keyword()) :: {:ok, map() | list()} | {:error, term()}
  def get(%__MODULE__{req: req}, path, opts \\ []) do
    case Req.get(req, url: path, params: Keyword.get(opts, :params, [])) do
      {:ok, %{status: status, body: body}} when status in 200..299 ->
        {:ok, body}

      {:ok, %{status: 401}} ->
        {:error, :authentication_error}

      {:ok, %{status: 403}} ->
        {:error, :authorization_error}

      {:ok, %{status: 404}} ->
        {:error, :not_found}

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
  Performs a POST request with JSON body.

  Scout's investigation endpoints primarily use POST requests.
  """
  @spec post(t(), String.t(), map(), keyword()) :: {:ok, map() | list()} | {:error, term()}
  def post(%__MODULE__{req: req}, path, data, _opts \\ []) do
    case Req.post(req, url: path, json: data) do
      {:ok, %{status: status, body: body}} when status in 200..299 ->
        {:ok, body}

      {:ok, %{status: 401}} ->
        {:error, :authentication_error}

      {:ok, %{status: 403}} ->
        {:error, :authorization_error}

      {:ok, %{status: 404}} ->
        {:error, :not_found}

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
end
