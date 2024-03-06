defmodule PocketUrl.Urls do
  @moduledoc """
  CRUD methods for the Url Schema
  """

  alias PocketUrl.Repo
  alias PocketUrl.Url

  @doc """
  Creates an url
  """
  def create(attrs \\ %{}) do
    %Url{}
    |> Url.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an url
  """
  def update(%Url{} = url, attrs \\ %{}) do
    url
    |> Url.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an url
  """
  def delete(%Url{} = url) do
    Repo.delete(url)
  end

  @doc """

  """
  def list(query \\ Url) do
    Repo.all(query)
  end

  @doc """
  Get url by id
  """
  def get(id) do
    Repo.get(Url, id)
  end

  @doc """
  Gets a url by specific params
  """
  def get_by(params \\ %{}) do
    Repo.get_by(Url, params)
  end
end
