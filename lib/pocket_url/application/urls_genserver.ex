defmodule PocketUrl.Application.UrlsGenServer do
  @moduledoc """
  A GenServer that manages the creation and retrieval of shortened URLs.

  It uses an ETS table to store the mapping between short codes and their corresponding URLs.
  The GenServer provides two main functions:

  - `create/2`: Creates a new shortened URL based on the given URL parameters.
  - `get/2`: Retrieves a shortened URL based on the given short code.

  When a shortened URL is retrieved, the visit count is incremented and the updated URL is stored back in the ETS table.
  """

  use GenServer

  alias PocketUrl.Urls

  @base_url Application.compile_env(:pocket_url, :base_url)
  @table :urls

  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @doc """
  Handles the `:create` message to create a new shortened URL.

  It takes the original URL as input and creates a new URL record using the `PocketUrl.Urls.create/1` function.
  If the URL is successfully created, it inserts the short code and the complete shortened URL into the ETS table.
  If there's an error during creation, it returns the error changeset.

  Returns `{:ok, url}` if the URL is successfully created, or `{:error, changeset}` if there's an error.
  """
  def create(params, opts \\ []) do
    GenServer.call(__MODULE__, {:create, params, opts})
  end

  @doc """
  Handles the `:get` message to retrieve a shortened URL based on the short code.

  It first looks up the short code in the ETS table. If found, it updates the visit count of the URL record
  using the `PocketUrl.Urls.update/2` function, inserts the updated URL back into the ETS table, and returns
  the updated URL.

  If the short code is not found in the ETS table, it tries to fetch the URL record from the database using
  `PocketUrl.Urls.get_by/1`. If the URL is found in the database, it updates the visit count, inserts it into
  the ETS table, and returns the updated URL. If the URL is not found in the database, it returns a `{:error, :not_found}` tuple.

  Returns `{:ok, updated_url}` if the URL is found and updated, or `{:error, :not_found}` if the URL is not found.
  """
  def get(params, opts \\ []) do
    GenServer.call(__MODULE__, {:get, params, opts})
  end

  # Callbacks

  @impl true
  def init(_) do
    table = :ets.new(@table, [:named_table, :set, :protected])

    {:ok, table}
  end

  @impl true
  def handle_call({:create, url, _opts}, _from, table) do
    case Urls.create(url) do
      {:ok, url} ->
        :ets.insert(table, {url.short_code, create_short_url(url)})

        {:reply, {:ok, url}, table}

      {:error, changeset} ->
        {:reply, {:error, changeset}, table}
    end
  end

  @impl true
  def handle_call({:get, short_code, _opts}, _from, table) do
    case :ets.lookup(table, short_code) do
      [{^short_code, url}] ->
        {:ok, updated_url} = Urls.update(url, %{visit_count: url.visit_count + 1})

        :ets.insert(table, {short_code, create_short_url(updated_url)})

        {:reply, {:ok, updated_url}, table}

      [] ->
        case Urls.get_by(%{short_code: short_code}) do
          nil ->
            {:reply, {:error, :not_found}, table}

          url ->
            {:ok, updated_url} = Urls.update(url, %{visit_count: url.visit_count + 1})

            :ets.insert(table, {short_code, create_short_url(updated_url)})

            {:reply, {:ok, updated_url}, table}
        end
    end
  end

  defp create_short_url(url) do
    Map.put(url, :short_url, "#{@base_url}/#{url.short_code}")
  end
end
