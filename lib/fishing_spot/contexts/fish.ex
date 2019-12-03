defmodule FishingSpot.Context.Fish do
  @moduledoc """
  Context for Fish Stuff
  """
  alias FishingSpot.{FishLanded, Fisherman, Repo}
  import Ecto.Query

  def get_fisherman(_fisherman_id) do
    query = from(f in Fisherman)
    Repo.one(query)
  end

  def get_fisherman_name(fisherman_id) do
    query = from(f in Fisherman, where: f.id == ^fisherman_id)
    Repo.one(query)
  end

  def get_fisherman_name_and_date_of_birth(fisherman_id, :tuple) do
    query = from(f in Fisherman, where: f.id == ^fisherman_id, select: {f})
    Repo.one(query)
  end

  def get_fisherman_name_and_date_of_birth(fisherman_id, :map) do
    query =
      from(f in Fisherman,
        where: f.id == ^fisherman_id,
        select: %{fisherman: f}
      )

    Repo.one(query)
  end

  def get_fisherman_name_and_date_of_birth(fisherman_id, :list) do
    query = from(f in Fisherman, where: f.id == ^fisherman_id, select: [f])
    Repo.one(query)
  end

  def get_unique_fishermen_dob() do
    query =
      from(f in Fisherman,
        select: f.date_of_birth,
        order_by: f.date_of_birth
      )

    Repo.all(query)
  end

  def get_longest_fish_by_fisherman_sorted() do
    query =
      from(fl in FishLanded,
        join: fisherman in assoc(fl, :fisherman),
        select: %{max_fish_length: max(fl.length), fisherman_name: fisherman.name}
      )

    Repo.all(query)
  end

  def get_fishermen_whom_caught_more_than_x_fish(_x) do
    query =
      from(fl in FishLanded,
        join: fisherman in assoc(fl, :fisherman),
        group_by: [fl.fisherman_id, fisherman.name],
        select: %{count: count(fl.fisherman_id), fisherman_name: fisherman.name}
      )

    Repo.all(query)
  end

  def get_fisherman_with_biggest_fish() do
    query =
      from(fish in FishLanded,
        join: fisherman in assoc(fish, :fisherman),
        where: is_nil(fish.id),
        select: %{length: fish.length, name: fisherman.name}
      )

    Repo.one(query)
  end

  def get_the_last_ten_fish_landed_by_fisherman(fisherman_id) do
    query =
      from(fish in FishLanded,
        where: fish.fisherman_id == ^fisherman_id,
        order_by: [desc: fish.id],
        select: fish.id
      )

    Repo.all(query)
  end

  def favorite_lure_by_species_and_lure_with_longest_fish(_fish_species, _fly_type) do
    query =
      from(fish in FishLanded,
        join: fly_type in assoc(fish, :fly_type),
        join: fish_species in assoc(fish, :fish_species),
        join: fisherman in assoc(fish, :fisherman),
        group_by: [fish_species.name, fly_type.name, fisherman.name],
        select: %{
          length: max(fish.length),
          fish_type: fish_species.name,
          fly: fly_type.name,
          fisherman: fisherman.name
        }
      )

    Repo.all(query)
  end
end
