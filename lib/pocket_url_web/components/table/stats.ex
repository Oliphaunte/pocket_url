defmodule PocketUrlWeb.Table.Stats do
  @moduledoc false

  use PocketUrlWeb, :live_component

  @base_url Application.compile_env(:pocket_url, :base_url)

  @impl true
  def mount(socket) do
    {:ok, socket |> assign(base_url: @base_url)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h3 :if={length(@urls.inserts) == 0} class="mt-8">Add some URLs to see some data!</h3>
      <.table :if={length(@urls.inserts) > 0} id="urls-table" rows={@urls}>
        <:col :let={{_dom_id, url}} label="Original URL"><%= url.original_url %></:col>
        <:col :let={{_dom_id, url}} label="Short Code URL">
          <.link href={"#{@base_url}/#{url.short_code}"}>
            <%= @base_url %>/<%= url.short_code %>
          </.link>
        </:col>
        <:col :let={{_dom_id, url}} label="Number of Visits"><%= url.visit_count %></:col>
      </.table>
    </div>
    """
  end
end
