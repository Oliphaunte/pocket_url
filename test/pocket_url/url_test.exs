defmodule PocketUrl.UrlTest do
  use PocketUrl.DataCase

  alias PocketUrl.Url

  describe "changeset/2" do
    test "validates required fields" do
      changeset = Url.changeset(%Url{}, %{})

      assert changeset.errors == [original_url: {"can't be blank", [validation: :required]}]
    end

    test "validates format of original_url" do
      attrs = %{original_url: "invalid_url"}
      changeset = Url.changeset(%Url{}, attrs)

      assert changeset.errors == [original_url: {"has invalid format", [validation: :format]}]
    end

    test "generates short_code when not provided" do
      attrs = %{original_url: "https://example.com"}
      changeset = Url.changeset(%Url{}, attrs)

      assert changeset.changes.short_code != nil
    end

    test "applies default value for visit_count" do
      attrs = %{original_url: "https://example.com"}
      changeset = Url.changeset(%Url{}, attrs)

      assert changeset.data.visit_count == 0
    end
  end
end
