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
    |> validate_exclusion(:name, ~w(joe pugliano))
    |> custom_validation()
  end

  defp custom_validation(changeset) do
    if get_change(changeset, :identifier, "") == "" do
      add_error(changeset, :identifier, "empty")
    else
      changeset
    end
  end
end
