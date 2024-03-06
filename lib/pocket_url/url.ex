defmodule PocketUrl.Url do
  @moduledoc """
  Represents a URL record in the database.

  The `Url` schema defines the structure of the "urls" table, which includes the following fields:
  - `original_url`: The original URL that is being shortened.
  - `short_code`: The generated short code for the URL.
  - `visit_count`: The number of times the shortened URL has been visited.

  The module provides a `changeset/2` function that validates and generates the necessary fields when creating or updating a URL record.

  The `original_url` field is validated using a regular expression to ensure it is a valid URL format.

  If the `short_code` field is not provided, a shortened slug is automatically generated using the first 6 characters of a UUID.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @url_regex ~r/^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w\.-]*)*\/?(\?[^"]*)?$/

  schema "urls" do
    field :original_url, :string
    field :short_code, :string
    field :visit_count, :integer, default: 0

    timestamps()
  end

  def changeset(url, attrs \\ %{}) do
    url
    |> cast(attrs, [:original_url, :visit_count])
    |> validate_required([:original_url])
    |> validate_format(:original_url, @url_regex)
    |> generate_shortened_slug()
  end

  defp generate_shortened_slug(changeset) do
    case get_field(changeset, :short_code) do
      nil ->
        slug = Ecto.UUID.generate() |> String.slice(0, 6)
        put_change(changeset, :short_code, slug)

      _ ->
        changeset
    end
  end
end
