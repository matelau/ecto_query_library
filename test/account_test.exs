defmodule FishingSpot.AccountTest do
  @moduledoc """
  """
  use FishingSpot.DataCase
  alias FishingSpot.Account
  alias Ecto.Changeset

  describe "" do
    test "create struct from changeset" do
      params = %{
        name: "some-name",
        identifier: "account_id",
        deposit: %{amount: 500}
      }

      account = %Account{} |> Account.changeset(params) |> Changeset.apply_changes()

      assert %Account{} = account
    end

    test "exclusion test" do
      params = %{
        name: "joe",
        identifier: "account_id"
      }

      changeset = %Account{} |> Account.changeset(params)

      assert changeset.errors == [
               name: {"is reserved", [validation: :exclusion, enum: ["joe", "pugliano"]]}
             ]
    end

    test "inclusion test" do
      params = %{
        name: "check",
        identifier: "identification"
      }

      changeset = %Account{} |> Account.changeset(params)

      assert changeset.errors == [
               identifier: {"is invalid", [validation: :inclusion, enum: ["account_id"]]}
             ]
    end

    test "custom validator test" do
      params = %{
        name: "hello",
        identifier: ""
      }

      changeset = %Account{} |> Account.changeset(params)

      assert changeset.errors == [identifier: {"empty", []}]
    end

    test "changeset casts embedded values to proper type" do
      params = %{
        name: "some-name",
        identifier: "account_id",
        deposit: %{amount: 500}
      }

      account = %Account{} |> Account.changeset(params) |> Changeset.apply_changes()
      assert account.deposit.amount == Decimal.cast(500)
    end
  end
end
