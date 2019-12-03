defmodule FishingSpot.Fisherman do
  use Ecto.Schema
  import Ecto.Changeset
  alias FishingSpot.FishermanTrip
  alias FishingSpot.FishLanded

  @fields [:name, :date_of_birth]

  schema "fishermen" do
    timestamps()
    field(:name, :string)
    field(:date_of_birth, :date)

    has_many(:fishermen_trips, FishermanTrip)
    has_many(:trips, through: [:fishermen_trips, :trip])
    has_many(:trip_locations, through: [:trips, :locations])
    has_many(:fish_landed, FishLanded)
  end

  def changeset(model, params) do
    model
    |> cast(params, @fields)
    |> cast_assoc(:fish_landed)
    |> validate_required([:date_of_birth])
    |> unique_constraint(:name, name: :fishermen_name)
  end
end
