defmodule PocketUrl.Application.UrlsGenServerTest do
  use ExUnit.Case, async: false

  alias PocketUrl.Application.UrlsGenServer
  alias PocketUrl.{Repo, Url}

  setup tags do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)

    :ok
  end

  test "create/1 creates a new short URL" do
    url_params = %{original_url: "https://www.example.com"}
    assert {:ok, %Url{} = url} = UrlsGenServer.create(url_params)
    assert url.original_url == url_params.original_url
    assert url.short_code != nil
  end

  test "get/1 retrieves a short URL by short code" do
    url_params = %{original_url: "https://www.example.com"}
    {:ok, created_url} = UrlsGenServer.create(url_params)

    assert {:ok, %Url{} = retrieved_url} = UrlsGenServer.get(created_url.short_code)
    assert retrieved_url.short_code == created_url.short_code
    assert retrieved_url.visit_count == created_url.visit_count + 1
  end

  test "get/1 returns an error for non-existent short code" do
    assert {:error, :not_found} = UrlsGenServer.get("nonexistent")
  end
end
