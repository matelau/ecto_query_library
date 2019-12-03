defmodule FishingSpot.FishLanded do
  alias FishingSpot.{Fisherman, FishSpecies, FlyType, Location}
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @fields [:date_and_time, :fisherman_id, :location_id, :weight, :length]
  @long_fish_min_length 100

  schema "fish_landed" do
    timestamps()
    field(:date_and_time, :naive_datetime)
    field(:weight, :decimal)
    field(:length, :decimal)

    belongs_to(:fisherman, Fisherman)
    belongs_to(:location, Location)
    belongs_to(:fly_type, FlyType)
    belongs_to(:fish_species, FishSpecies)
  end

  def changeset(model, params) do
    model
    |> cast(params, @fields)
  end

  def largest_fish(query) do
    from(fl in query, select: max(fl.weight))
  end

  def by_length(query, length) do
    from(fl in query, where: fl.length == ^length)
  end

  def count(query) do
    from(fl in query, select: count(fl.id))
  end

  def count_long_fish(query) do
    from(fl in query, select: count(fl.id), where: fl.length > @long_fish_min_length)
  end
end
