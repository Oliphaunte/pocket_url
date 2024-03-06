# PocketUrl

A URL shortener, built with Phoenix, Elixir, Genservers, ETS, and Postgres

All URLs are saved to our Postgres DB, with concurrency through Genservers and an :ets table connected to our database instance.

You will need the following pieces to run the application:

- Elixir/Erlang
- Phoenix
- Postgres
- PNPM/NPM/Yarn

All instructions assume you are working with an Apple environment

# Setup

If you are missing any of the prerequisites, please follow the instructions at the bottom of this document.

If you have all the prerequisites, follow the steps below to get the site running on local:

1. Run `touch config/local.secret.exs` (or manually add the `local.secret.exs` file to the config folder)
2. Inside the `local.secret.exs`, add the following and replace the prompts:

```
import Config

config :pocket_url, PocketUrl.Repo,
  username: "REPLACE_ME_WITH_YOUR_POSTGRES_USERNAME",
  password: "REPLACE_ME_WITH_YOUR_POSTGRES_PASSWORD"
```

3. Run `mix ecto.setup`
4. `cd` in the `/assets` folder and run `pnpm install` (or, npm or yarn, depending on your choice)
5. `cd` back into the root and run `mix phx.server` and visit the url at the localhost `https://localhost:4001`
6. You can also run `mix test` to run the validation tests.

# Installation

You can skip any of the following steps if you already have the target downloaded.

1. Homebrew

- https://brew.sh/
- `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

2. Elixir

- `brew install elixir`

3. Erlang

- `brew install erlang`

If you wish to user a version manager for Elixir and Erlang, I would recommend `asdf`

4. Phoenix

- https://hexdocs.pm/phoenix/installation.html
- `mix local.hex`
- `mix archive.install hex phx_new`

5. Postgres

- `brew install postgresql`
- Follow the commands from brew post-installation

6. PNPM/NPM/Yarn

- If you wish to use any of the following, you can install them through brew as well. I would recommend PNPM, but for simplicity, NPM works
