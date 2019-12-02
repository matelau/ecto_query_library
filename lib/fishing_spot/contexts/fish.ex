defmodule FishingSpot.Context.Fish do
  @moduledoc """
  Context for Fish Stuff
  """
  alias FishingSpot.{Fisherman, Repo}
  import Ecto.Query

  def get_fisherman(fisherman_id) do
    query = from(f in Fisherman, where: f.id == ^fisherman_id)
    Repo.one(query)
  end

  def get_fisherman_name(fisherman_id) do
    query = from(f in Fisherman, where: f.id == ^fisherman_id, select: f.name)
    Repo.one(query)
  end

  def get_fisherman_name_and_date_of_birth(fisherman_id, :tuple) do
    query = from(f in Fisherman, where: f.id == ^fisherman_id, select: {f.name, f.date_of_birth})
    Repo.one(query)
  end

  def get_fisherman_name_and_date_of_birth(fisherman_id, :map) do
    query =
      from(f in Fisherman,
        where: f.id == ^fisherman_id,
        select: %{name: f.name, dob: f.date_of_birth}
      )

    Repo.one(query)
  end

  def get_fisherman_name_and_date_of_birth(fisherman_id, :list) do
    query = from(f in Fisherman, where: f.id == ^fisherman_id, select: [f.name, f.date_of_birth])
    Repo.one(query)
  end

  def get_unique_fishermen_names() do
    query = from(f in Fisherman, select: f.name, distinct: f.name)
    Repo.all(query)
  end
end
