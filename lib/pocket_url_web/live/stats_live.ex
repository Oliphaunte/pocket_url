defmodule PocketUrlWeb.StatsLive do
  use PocketUrlWeb, :live_view

  alias PocketUrl.Urls

  @impl true
  def mount(_params, _session, socket) do
    urls = Urls.list()

    {:ok, socket |> stream(:urls, urls)}
  end

  @impl true
  def handle_event("download_csv", _params, socket) do
    urls = Urls.list()
    {:noreply, push_event(socket, "download_csv", %{data: generate_csv_data(urls)})}
  end

  defp generate_csv_data(urls) do
    headers = [["Original URL", "Short Code", "Visits Count"]]

    rows =
      Enum.map(urls, fn url ->
        [url.original_url, url.short_code, url.visit_count]
      end)

    (headers ++ rows)
    |> CSV.encode()
    |> Enum.to_list()
    |> to_string()
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="t__stats-page" phx-hook="CSV">
      <button
        :if={length(@streams.urls.inserts) > 0}
        type="button"
        class="mt-8 mx-4 py-3 px-4 inline-flex items-center gap-x-2 text-sm font-semibold rounded-lg border border-transparent bg-yellow-100 text-yellow-800 hover:bg-yellow-200 disabled:opacity-50 disabled:pointer-events-none dark:hover:bg-yellow-900 dark:text-yellow-500 dark:hover:text-yellow-400 dark:focus:outline-none dark:focus:ring-1 dark:focus:ring-gray-600"
        phx-click="download_csv"
      >
        Download CSV
      </button>

      <div class="px-4">
        <.live_component module={PocketUrlWeb.Table.Stats} id="stats-table" urls={@streams.urls} />
      </div>
    </div>
    """
  end
end
