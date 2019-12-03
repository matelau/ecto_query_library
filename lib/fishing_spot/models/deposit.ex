defmodule FishingSpot.Deposit do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:amount]

  embedded_schema do
    field(:amount, :decimal)
  end

  def changeset(model, params) do
    model
    |> cast(params, @fields)
  end
end
