defmodule PocketUrl.Repo.Migrations.CreateUrls do
  use Ecto.Migration

  def change do
    create table(:urls) do
      add :original_url, :string
      add :short_code, :string
      add :visit_count, :integer, default: 0

      timestamps()
    end

    create unique_index(:urls, [:short_code])
  end
end
