defmodule FishingSpot.Context.Fish do
  @moduledoc """
  Context for Fish Stuff
  """
  alias FishingSpot.{FishLanded, Fisherman, Repo}
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

  def get_unique_fishermen_dob() do
    query =
      from(f in Fisherman,
        select: f.date_of_birth,
        distinct: f.date_of_birth,
        order_by: f.date_of_birth
      )

    Repo.all(query)
  end

  def get_longest_fish_by_fisherman_sorted() do
    query =
      from(fl in FishLanded,
        join: fisherman in assoc(fl, :fisherman),
        group_by: [fisherman.name, fl.length],
        order_by: [desc: fl.length],
        select: %{max_fish_length: max(fl.length), fisherman_name: fisherman.name}
      )

    Repo.all(query)
  end

  def get_fishermen_whom_caught_more_than_2_fish() do
    query =
      from(fl in FishLanded,
        join: fisherman in assoc(fl, :fisherman),
        group_by: [fl.fisherman_id, fisherman.name],
        having: count(fl.fisherman_id) > 2,
        select: %{count: count(fl.fisherman_id), fisherman_name: fisherman.name}
      )

    Repo.all(query)
  end
end
