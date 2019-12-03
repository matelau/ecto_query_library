defmodule FishingSpot.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias FishingSpot.Deposit
  @fields [:identifier, :name]

  embedded_schema do
    timestamps()
    field(:identifier, :string)
    field(:name, :string)
    embeds_one(:deposit, Deposit)
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @fields)
    |> cast_embed(:deposit)
  end
end
