defmodule PocketUrlWeb.RedirectControllerTest do
  use PocketUrlWeb.ConnCase

  alias PocketUrl.{Repo, Url}

  test "redirects to the original URL", %{conn: conn} do
    url = Repo.insert!(%Url{original_url: "https://www.example.com", short_code: "abc123"})

    conn = get(conn, "/#{url.short_code}")
    assert redirected_to(conn) == "https://www.example.com"

    updated_url = Repo.get(Url, url.id)
    assert updated_url.visit_count == 1
  end

  test "returns an error for invalid short code", %{conn: conn} do
    conn = get(conn, "/invalid")
    assert redirected_to(conn) == "/"
    assert Phoenix.Flash.get(conn.assigns.flash, :error) == "Invalid short code"
  end
end
