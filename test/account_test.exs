defmodule FishingSpot.AccountTest do
  @moduledoc """
  """
  use FishingSpot.DataCase
  alias FishingSpot.Account
  alias Ecto.Changeset

  describe "" do
    test "changeset casts embedded values to proper type" do
      params = %{
        name: "some-name",
        identifier: "account_id",
        deposit: %{amount: 500}
      }

      account =
        %Account{} |> Account.changeset(params) |> Changeset.apply_changes() |> IO.inspect()

      assert account.deposit.amount == Decimal.cast(500)
    end
  end
end
