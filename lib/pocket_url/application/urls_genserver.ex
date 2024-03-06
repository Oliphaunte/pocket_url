defmodule PocketUrl.Application.UrlsGenServer do
  @moduledoc """

  """

  use GenServer

  alias PocketUrl.Urls

  @base_url Application.compile_env(:pocket_url, :base_url)
  @table :urls

  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def create(params, opts \\ []) do
    GenServer.call(__MODULE__, {:create, params, opts})
  end

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
