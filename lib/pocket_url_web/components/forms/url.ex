defmodule PocketUrlWeb.Forms.Url do
  @moduledoc false

  use PocketUrlWeb, :live_component

  alias PocketUrl.Url
  alias PocketUrl.Application.UrlsGenServer

  @impl true
  def mount(socket) do
    changeset = %Url{original_url: ""} |> Url.changeset()

    {:ok, socket |> assign_form(changeset)}
  end

  @impl true
  def handle_event("submit-url", %{"url" => url}, socket) do
    case UrlsGenServer.create(url) do
      {:ok, url} ->
        send(self(), {:url_shortened, url})

        changeset = %Url{original_url: ""} |> Url.changeset()

        {:noreply, assign_form(socket, changeset)}

      {:error, changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-wrap justify-center w-full">
      <.simple_form id="shorten-url-form" for={@form} phx-submit="submit-url" phx-target={@myself}>
        <.input
          type="text"
          field={@form[:original_url]}
          phx-debounce="500"
          placeholder="https://example-url.ex"
        />

        <.button phx-disable-with="Submitting..." class="w-full">Submit</.button>
      </.simple_form>
    </div>
    """
  end
end
