defmodule PocketUrlWeb.RedirectController do
  use PocketUrlWeb, :controller

  alias PocketUrl.Application.UrlsGenServer

  def show(conn, %{"short_code" => short_code}) do
    case UrlsGenServer.get(short_code) do
      {:ok, url} ->
        redirect(conn, external: url.original_url)

      {:error, :not_found} ->
        conn
        |> put_flash(:error, "Invalid short code")
        |> redirect(to: "/")
        |> halt()
    end
  end
end
