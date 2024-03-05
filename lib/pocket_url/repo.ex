defmodule PocketUrl.Repo do
  use Ecto.Repo,
    otp_app: :pocket_url,
    adapter: Ecto.Adapters.Postgres
end
