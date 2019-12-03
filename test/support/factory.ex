defmodule EctoQueryLibray.Factory do
  @moduledoc """
  Factory for EctoQueryLibrary
  """
  use ExMachina.Ecto, repo: FishingSpot.Repo

  alias FishingSpot.{Fisherman, FishLanded, FishSpecies, FlyType, Location, LocationType}

  def fisherman_factory do
    %Fisherman{
      name: "Fisherman",
      date_of_birth: DateTime.utc_now()
    }
  end

  def fish_landed_factory do
    %FishLanded{
      date_and_time: DateTime.utc_now(),
      weight: Decimal.cast(1.0),
      length: Decimal.cast(1.0),
      fisherman: insert(:fisherman, name: sequence(:name, &"name-#{&1}")),
      location: insert(:location),
      fly_type: insert(:fly_type),
      fish_species: insert(:fish_species)
    }
  end

  def location_factory do
    %Location{
      name: "Fishing Hole",
      altitude: 1,
      lat: Decimal.cast(1.0),
      long: Decimal.cast(1.0),
      location_type: insert(:location_type)
    }
  end

  def location_type_factory do
    %LocationType{
      name: "River"
    }
  end

  def fly_type_factory do
    %FlyType{
      name: "Yummy"
    }
  end

  def fish_species_factory do
    %FishSpecies{
      name: "Trout"
    }
  end
end
