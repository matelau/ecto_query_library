defmodule FishingSpot.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias FishingSpot.Deposit
  @fields [:identifier, :name]

  schema "accounts" do
    timestamps()
    field(:identifier, :string)
    field(:name, :string)
    embeds_one(:deposit, Deposit)
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @fields)
    |> cast_deposit()
  end

  defp cast_deposit(changeset) do
    if(is_nil(get_field(changeset, :deposit))) do
      changeset
    else
      cast_embed(changeset, :deposit)
    end
  end
end
