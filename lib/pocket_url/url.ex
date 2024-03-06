defmodule PocketUrl.Url do
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
